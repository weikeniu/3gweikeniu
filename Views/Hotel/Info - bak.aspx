<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%
    hotel3g.Models.Hotel hotel = ViewData["hotel"] as hotel3g.Models.Hotel;
    string weixinID = string.Empty;
    if (hotel != null && !string.IsNullOrEmpty(hotel.WeiXinID))
    {
        weixinID = hotel.WeiXinID;
    }
    else
    {
        weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
        if (weixinID.Equals(""))
        {
            string key = HotelCloud.Common.HCRequest.GetString("key");
            weixinID = key.Split('@')[0];
        }
    }
    string userweixinid = ViewData["userWeiXinID"]as string;

    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", weixinID);
    viewDic.Add("hId", hotel.ID);
    viewDic.Add("uwx", userweixinid);
    
%>
<head>
    <meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"
        name="viewport">
    <meta name="Keywords" content="">
    <meta name="Description" content="">
    <!-- Mobile Devices Support @begin -->
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
    <meta content="no-cache,must-revalidate" http-equiv="Cache-Control">
    <meta content="no-cache" http-equiv="pragma">
    <meta content="0" http-equiv="expires">
    <meta content="telephone=no, address=no" name="format-detection">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!-- apple devices fullscreen -->
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <title>
        <%=hotel.SubName %>官网</title>
         <link href="http://css.weikeniu.com/css/booklist/sale-date.css?v=1.0" rel="stylesheet" type="text/css" />
    <link href="http://css.weikeniu.com/css/css.css?vison=1.0 %>" rel="stylesheet" type="text/css" />
      <script src="http://js.weikeniu.com/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <%Html.RenderPartial("JSHeader"); %>
</head>
<body>
    <div class="logo cl">
        <img src="<%=hotel.HotelLog %>" />
    </div>
    <div class="all">
        <div class="tel">
            <table>
                <tr>
                    <td class="ont">
                        <ul>
                            <li><a href="tel:<%=hotel.Tel%>">电话：<%=hotel.Tel%></a></li>
                        </ul>
                    </td>
                    <td class="ert">
                        <%--<a href="#">
                            <img src="/img/youdok_11.png" /></a>--%>
                    </td>
                </tr>
                <tr>
                    <td class="ont">
                        <ul>
                            <li><a href="javascript:void(0);">开业：<%=hotel.openDate %></a></li>
                        </ul>
                    </td>
                    <td class="ert">
                        <%--<a href="#">
                            <img src="/img/youdok_11.png" /></a>--%>
                    </td>
                </tr>
                <tr>
                    <td class="ont">
                        <ul>
                            <li><a href="javascript:void(0);">装修：<%=hotel.xiuDate%></a></li>
                        </ul>
                    </td>
                    <td class="ert">
                        <%-- <a href="#">
                            <img src="/img/youdok_11.png" /></a>--%>
                    </td>
                </tr>
                <tr>
                    <td class="ont">
                        <ul>
                            <li><a href="javascript:void(0);">附近：</a><span style="float: inherit"><%=ViewData["fujin"]%></span>
                            </li>
                        </ul>
                    </td>
                    <td class="ert">
                    </td>
                </tr>
                <tr class="laxx" id="openmap">
                    <td class="ont">
                        <ul>
                            <li><a href="javascript:void(0);">地址：<%=hotel.Address %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span>查看地图</span></a></li>
                        </ul>
                    </td>
                    <td class="ert">
                        <a href="javascript:void(0)">
                            <img src="/img/youdok_11.png" /></a>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="all">
        <div class="jianjietop">
            <strong>酒店简介</strong>
        </div>
        <div class="jianjiecon">
            <p>
                <%=hotel.Content %></p>
            <br />
            <%
                IList<hotel3g.Models.Img> mlist = ViewData["image"] as IList<hotel3g.Models.Img>;
                if (mlist != null)
                {
                    foreach (hotel3g.Models.Img g in mlist)
                    { %>
            <center><img src="<%=g.Url %>" /></center>
            <%}
                }
            %>
        </div>
        <div class="gengduotu cl">
            <a href="/Hotel/Images/<%=hotel.ID %>?key=<%=weixinID %>@<%=userweixinid %>">更多酒店图片</a></div>
        <div class="gengduotu cl">
            <a href="/Hotel/NewsinfoList/<%=hotel.ID %>?key=<%=weixinID %>@<%=userweixinid %>">酒店优惠活动</a></div>
    </div>
    <%Html.RenderPartial("Copyright"); %>

    <%    
        Html.RenderPartial("Footer", viewDic); 
    %>
</body>
</html>
<%Html.RenderPartial("JS"); %>
<script type="text/javascript">
    $(function () {
        $('#openmap').on('click', function () {
            location.href = "/Hotel/Map/<%=hotel.ID %>?key=<%=weixinID %>@<%=userweixinid %>";
        });
    });
</script>
