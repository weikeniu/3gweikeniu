<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<% 
    hotel3g.Models.Hotel hotel = ViewData["hotel"] as hotel3g.Models.Hotel;
    IList<hotel3g.Common.FacilityImages> imgs = ViewData["facImagfe"] as IList<hotel3g.Common.FacilityImages>;

    ViewDataDictionary jdata = new ViewDataDictionary();
    jdata.Add("weixinID", ViewData["weixinID"]);
    jdata.Add("hId", ViewData["hId"]);
    jdata.Add("uwx", ViewData["userWeiXinID"]);

    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", ViewData["weixinID"]);
    viewDic.Add("hId", ViewData["hId"]);
    viewDic.Add("uwx", ViewData["userWeiXinID"]);

    ViewData["hotelname"] = hotel.SubName;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
    <title>  <%= ViewData["hotelname"]%>
    设施服务</title>
    <link href="http://css.weikeniu.com/css/booklist/sale-date.css?v=1.0" rel="stylesheet">
       <script src="http://js.weikeniu.com/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <link href="http://css.weikeniu.com/css/css.css" rel="stylesheet" type="text/css" />
   
</head>
<body>
    <%
        if (!string.IsNullOrEmpty(hotel.FuWu))
        {%>
    <div class="all" style="padding-bottom: 0px;">
        <div class="jianjietop">
            <strong>酒店服务</strong>
        </div>
        <div class="jianjiecon" style="padding: 0px;">
            <p>
                <%=string.IsNullOrEmpty(hotel.FuWu)?string.Empty:hotel.FuWu.Replace(";","；") %></p>
        </div>
    </div>
    <% }
    %>
    <%
        if (!string.IsNullOrEmpty(hotel.KeFang))
        {%>
    <div class="all" style="padding-bottom: 0px;">
        <div class="jianjietop">
            <strong>客房设施</strong>
        </div>
        <div class="jianjiecon" style="padding: 0px;">
            <p>
                <%=string.IsNullOrEmpty(hotel.KeFang)?string.Empty:hotel.KeFang.Replace(";","；") %></p>
        </div>
    </div>
    <%}
    %>
    <%
        if (!string.IsNullOrEmpty(hotel.CanYin))
        {%>
    <div class="all" style="padding-bottom: 0px;">
        <div class="jianjietop">
            <strong>餐饮设施</strong>
        </div>
        <div class="jianjiecon" style="padding: 0px;">
            <p>
                <%=string.IsNullOrEmpty(hotel.CanYin) ? string.Empty : hotel.CanYin.Replace(";", "；")%></p>
            <%
       
            
                foreach (hotel3g.Common.FacilityImages mg in imgs)
                {
                    //去除空白项图片
                    mg.Images = mg.Images.Where(e => !string.IsNullOrEmpty(e)).ToList();
                    if (mg.TypeId == 3)
                    {
                        if (mg.Images != null && mg.Images.Count > 0)
                        {
                            int i = 1;
                            foreach (string u in mg.Images)
                            {
                                if (i == 1)
                                {%>
            <p>
                <strong>
                    <%=mg.Title %></strong>：<%=mg.Description %></p>
            <%}
                                if (!string.IsNullOrEmpty(u))
                                { %>
            <center>
                <img src="<%=u %>" /></center>
            <%}
            %>
            <%
                i++;
                            }
                        }
                    }
                }
            %>
        </div>
    </div>
    <%}
    %>
    <%
        if (!string.IsNullOrEmpty(hotel.YuLe))
        {%>
    <div class="all">
        <div class="jianjietop">
            <strong>康体娱乐</strong>
        </div>
        <div class="jianjiecon" style="padding: 0px;">
            <p>
                <%=string.IsNullOrEmpty(hotel.YuLe) ? string.Empty : hotel.YuLe.Replace(";","；")%></p>
            <%
                foreach (hotel3g.Common.FacilityImages mg in imgs)
                {
                    if (mg.TypeId == 4)
                    {
                        if (mg.Images != null)
                        {
                            int i = 1;
                            foreach (string u in mg.Images)
                            {
                                if (i == 1)
                                {%>
            <p>
                <strong>
                    <%=mg.Title %></strong>：<%=mg.Description %></p>
            <%}
                                if (!string.IsNullOrEmpty(u))
                                { %>
            <center>
                <img src="<%=u %>" /></center>
            <% }
            %>
            <%
                i++;
                            }
                        }
                    }
                }
            %>
        </div>
    </div>
    <%}
    %>
 
    <%Html.RenderPartial("Footer", viewDic); %>
</body>
</html>
 
<%
       
       
    string hotelWeixinid = ViewData["weixinID"].ToString();
    string hid = ViewData["hId"].ToString();
    string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
    string openid = ViewData["userWeiXinID"].ToString();
    string newkey = string.Format("{0}@{1}", hotelWeixinid, openid);
    if (!openid.Contains(wkn_shareopenid))
    {
        //非二次分享 获取推广员信息
        var CurUser = hotel3g.Repository.MemberHelper.GetMemberCardByUserWeiXinNO(hotelWeixinid, openid);
        ///原链接已经是分享过的链接
        newkey = string.Format("{0}@{1}_{2}", hotelWeixinid, wkn_shareopenid, CurUser.memberid);
    }

    string sharelink = string.Format("http://hotel.weikeniu.com{0}?key={1}", Request.Url.LocalPath, newkey);
    hotel3g.PromoterEntitys.WeiXinShareConfig WeiXinShareConfig = new hotel3g.PromoterEntitys.WeiXinShareConfig()
    {
        title = null,
        desn = null,
        logo = null,
        debug = false,
        userweixinid = openid,
        weixinid = hotelWeixinid,
        hotelid = int.Parse(hid),
        sharelink = sharelink
    };
    viewDic.Add("WeiXinShareConfig", WeiXinShareConfig);
    Html.RenderPartial("WeiXinShare", viewDic); 
%>