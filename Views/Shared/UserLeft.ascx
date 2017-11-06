<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%
    string userWeiXinID = ""; 
    string weixinID = ViewData["weixinid"] as string;
    userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO",weixinID);
   
    string id = ViewData["id"] as string;
     %>
 <ul class="nav">
            	<li>
                	<a href="/User/MyOrders/<%=id %>?weixinID=<%=weixinID %>">我的订单<span></span></a>
                </li>
                <li>
                	<a href="/User/JiFen/<%=id %>?weixinID=<%=weixinID %>">我的积分<span></span></a>
                </li>
                <li>
                	<a href="/User/MyCouPons/<%=id %>?weixinID=<%=weixinID %>">优惠券<span></span></a>
                </li>
                <li>
                	<a href="/User/MyReWard/<%=id %>?weixinID=<%=weixinID %>">中奖记录<span></span></a>
                </li>
                <li>
                	<a href="/User/UserInfo/<%=id %>?weixinID=<%=weixinID %>">个人信息<span></span></a>
                </li>
            </ul>