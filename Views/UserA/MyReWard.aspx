<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    System.Data.DataTable dt = ViewData["dt"] as System.Data.DataTable;

    ViewDataDictionary jdata = new ViewDataDictionary();
    jdata.Add("weixinID", ViewData["weixinID"]);
    jdata.Add("hId", ViewData["hId"]);
    jdata.Add("uwx", ViewData["userWeiXinID"]);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <title>中奖明细</title>
    <meta name="format-detection" content="telephone=no"/>
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes"/>
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*"/>
    <link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css" />
    <link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/new-style.css" />
    <link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/mend-reset.css" />
    <script src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <script src="http://css.weikeniu.com/Scripts/fontSize.js"></script>
</head>
<body>
    <!-- <>主体页面 -->
    <article class="full-page">
		<!--//侧边栏-->

		<section class="show-body">
                  <section class="content2">
                        	<!--//中奖明细-->
	                    	<div class="ca-ivdetail-top">
		                        <a class="ca-return-icon fl" href="javascript:history.go(-1);"></a>
		                        <div class="hd-mx fr"><a href="javascript:;"><i class="ico-hdmx i4"></i>中奖明细</a></div>
							</div>



                                    <%  if (dt != null && dt.Rows.Count > 0)
                                        {
                                       
                    
                       %>

                        	<!--ca-ivdetail-top end-->
                        	<div class="ca-ivdetail-content">
                                <div class="ivdetail-table">
                                          <table cellpadding="0" cellspacing="0" border="0">
                                                 <thead>


                                                          <tr>
                                                               <td colspan="3">
                                                                    <div class="ca-iv-times">
                                                                         <div class="ca-invo-detail"><%=DateTime.Now.ToString("yyyy年M月") %></div>
                                                                    </div>
                                                                    <!--ca-iv-times end-->
                                                               </td>
                                                          </tr>
                                                  </thead>

                                                  <tbody>
                                                 <%
                                                     string[] weekdays = { "周日", "周一", "周二", "周三", "周四", "周五", "周六" };
                                                     foreach (System.Data.DataRow dr in dt.Rows)
                                                     {
                                                         string class_ico = dr["Result"].ToString().Contains("优惠券") ? "hb-ico" : "jp-ico";

                                                         string value = dr["Result"].ToString().Replace("优惠券", "").Replace("元红包", "");
                                                         decimal num = 0;

                                                         string tip = "订房红包";
                                                         string money = "";
                                                         if (decimal.TryParse(value, out num))
                                                         {
                                                             value = "￥" + dr["Result"].ToString().Replace("元优惠券", "元订房红包");
                                                             money = value;
                                                         }
                                                         else
                                                         {
                                                             value = dr["Result"].ToString().Replace("元优惠券", "").Replace("元红包", "");
                                                             tip = value;
                                                         }

                                                         string week = weekdays[Convert.ToInt32(Convert.ToDateTime(dr["Choujiangtime"].ToString()).DayOfWeek)];
                                                         DateTime Time = Convert.ToDateTime(dr["Choujiangtime"].ToString());

                                                         string title = string.Empty;
                                                         string PrizeLevel = dr["PrizeLevel"].ToString();

                                                         switch (PrizeLevel) {
                                                             case "1": title = "一等奖"; break;
                                                             case "2": title = "二等奖"; break;
                                                             case "3": title = "三等奖"; break;
                                                             case "4": title = "谢谢参与"; break;
                                                             case "5": title = "四等奖"; break;
                                                             case "6": title = "五等奖"; break;
                                                             case "7": title = "六等奖"; break;
                                                             case "8": title = "七等奖"; break;
                                                             case "9": title = "八等奖"; break;
                                                             case "10": title = "免单"; break;  
                                                         }
                                                         
                                                 %>


                                                    <tr>
                                                               <td  class="ca-small-time"><div><%=title %></div></td>
                                                               <td><div class="ca-by-begin"><span><i class="i1"></i></span>
                                                                        <!--<dl class="yu-lpad60r">
                                                                              <dt>订房红包 ￥168</dt>
                                                                              <dd>￥168</dd>
                                                                        </dl>-->
                                                                        <div class="yu-l60r"> <%=tip %></div>
                                                                   </div>
                                                               </td>
                                                               <td align="right"><div class="ca-no-condition"><span class="ca-f40"><%=Time.ToString("yyyy-MM-dd") %> <br> <%=Time.ToString("HH:mm:ss")%></span></div></td>
                                                          </tr>


                                                       
                                                         <%-- <tr>
                                                               <td class="ca-small-time"><div><%=week %><br/><%=Convert.ToDateTime(dr["Choujiangtime"].ToString()).ToString("MM-dd")%></div></td>
                                                               <td><div class="ca-by-begin"><span><i class="i3"></i></span>
                                                                         <dl>
                                                                              <dt><%=tip %></dt>
                                                                             
                                                                              <dd><%=money %></dd>
                                                                      
                                                                         </dl>
                                                                   </div>
                                                               </td>
                                                               <td align="right" style="display:none;"><div class="ca-no-condition"><span class="ca-f40">已领取</span></div></td>
                                                          </tr>--%>
                                                           <%}%>
                                                  </tbody>

                                          </table>

                                </div>
                               <%-- <div class="uc__loading-tips">
									加载中...
								</div>--%>
                        	</div>
                        	<!--ca-ivdetail-content end-->

            <%   }%>
            <% else
                { %>
        <div class="uc__storeValCard-details">
						<div class="no-data">
							<img src="http://css.weikeniu.com/images/icon__no-winning.png" />
							<h2>还没有中奖明细</h2>
							<p>过段时间再来瞧瞧吧</p>
							<a class="back" href="javascript:history.go(-1);">返回</a>
						</div>
					</div>

            <%  } %>

                  </section>
		</section>
	</article>
</body>
</html>
