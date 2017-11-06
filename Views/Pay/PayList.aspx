<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
    string userweixinid = HotelCloud.Common.HCRequest.GetString("userweixinid");
    string hotelid = RouteData.Values["id"].ToString();
    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", weixinID);
    viewDic.Add("hId", hotelid);
    viewDic.Add("uwx", userweixinid);
    string tmpdate = HotelCloud.Common.HCRequest.GetString("indate");
    if (!string.IsNullOrEmpty(tmpdate))
    {
        DateTime tmpd = Convert.ToDateTime(tmpdate);
        if (tmpd != null)
        {
            tmpdate = tmpd.ToString("MM月dd日");
        }
    }

    string cardno = ViewData["cardno"] as string;
    hotel3g.Repository.MemberInfo MemberInfoDeatil = ViewData["MemberInfo"] as hotel3g.Repository.MemberInfo;
    hotel3g.Repository.MemberCard MemberCard = ViewData["MemberCard"] as hotel3g.Repository.MemberCard;
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"
        name="viewport">
    <meta name="Keywords" content="">
    <meta name="Description" content="">
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
    <meta content="no-cache,must-revalidate" http-equiv="Cache-Control">
    <meta content="no-cache" http-equiv="pragma">
    <meta content="0" http-equiv="expires">
    <meta content="telephone=no, address=no" name="format-detection">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <title>支付列表</title>
    <link href="../../css/css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .form-style
        {
            overflow: hidden;
            background: #fff;
            margin-bottom: 5px;
            border-bottom: 1px solid #ddd;
        }
        .form-style > ul
        {
            font: 14px/50px Microsoft YaHei,SimHei;
            width: 100%;
        }
        .form-style > ul > li
        {
            position: relative;
            padding: 0 30px 0 10px;
            width: 100%;
            box-sizing: border-box;
            -moz-box-sizing: border-box;
            -o-box-sizing: border-box;
            -webkit-box-sizing: border-box;
            border-top: 1px solid #ddd;
            overflow: hidden;
        }
        .zfb
        {
            background: url(/Images/payicon.png) no-repeat -47px -3px;
        }
        .pay-icon
        {
            width: 40px;
            height: 39px;
            float: left;
            margin: 6px 10px 0 0;
        }
    </style>
    <%Html.RenderPartial("JSHeader"); %>
    <script src="../../Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
</head>
<%Html.RenderPartial("JSHeader"); %>
<body>
    <div class="all" id="mainDiv">
        <div class="top cl">
            <h1>
                支付</h1>
        </div>
        <div class="cont">
            <%
                hotel3g.Repository.Order info = ViewData["data"] as hotel3g.Repository.Order;
                if (info != null)
                {
            %>
            <dl>
                <dt>酒店名称</dt>
                <dd id="Dd1">
                    <%=info.HotelName %>
                </dd>
            </dl>
            <dl>
                <dt>预定价格</dt>
                <dd>
                    <strong id="Strong1">￥
                        <%-- <%
                        if (!string.IsNullOrEmpty(cardno))
                        {
                            decimal rate = 10;
                            if (MemberCard.night >= MemberInfoDeatil.vip4 && MemberInfoDeatil.vip4>0)
                            {
                                rate = MemberInfoDeatil.vip4rate;
                            }
                            else if (MemberCard.night >= MemberInfoDeatil.vip3 && MemberInfoDeatil.vip3> 0)
                            {
                                rate = MemberInfoDeatil.vip3rate;
                            }
                            else if (MemberCard.night >= MemberInfoDeatil.vip2 && MemberInfoDeatil.vip2 > 0)
                            {
                                rate = MemberInfoDeatil.vip2rate;
                            }
                            else if (MemberCard.night >= MemberInfoDeatil.vip1 && MemberInfoDeatil.vip1 > 0)
                            {
                                rate = MemberInfoDeatil.vip1rate;
                            } else if (MemberCard.night >= MemberInfoDeatil.vip0 && MemberInfoDeatil.vip0 > 0)
                            {
                                rate = MemberInfoDeatil.vip0rate;
                            }

                            info.OrderAmount = (int)Math.Ceiling((info.OrderAmount* (rate/10)));
                        }
                 %>--%>
                        <%=info.OrderAmount %></strong><strong>元</strong>
                </dd>
            </dl>
            <%-- <ul class="turn-pay" id="xp">
                    <li paytype="003"><div class="pay-icon-box"><p class="pay-icon zfb"></p></div>支付宝支付</li>
                </ul>--%>
            <section class="form-style" style="margin-top: 10px">
            <ul class="turn-pay" id="xp">


                <li paytype="003" style=" display:none;">
                    <div class="pay-icon zfb"></div>
                    支付宝支付
                </li>
                <li paytype="004">
                    <div class="pay-icon wx" style="background: url(/Images/payicon.png) no-repeat 1px -3px;"></div>
                    微信支付
                </li>








            </ul>
            </section>
            <p class="note">
                <%--如果不能在<strong id="date"></strong><strong id="time"></strong>，请联系酒店 <span id="tel">
                </span>协商房间保留事宜。以免房间被过时取消。--%>
            </p>
            <div class="mashang cl" id="giftcoupon" style="display: none">
                <strong></strong>！</div>
            <input type="hidden" id="oid" value="<%=info.Id %>" />
            <%} %>
        </div>
    </div>
    <div class="cccont cl">
    </div>
    <div id="iframe" style="display: none;">
        <iframe src="" style="width: 99%; height: 879px;" id="hmain" frameborder="no" border="0"
            marginwidth="0" marginheight="0" scrolling="no" allowtransparency="yes"></iframe>
    </div>
    <%Html.RenderPartial("Copyright"); %>
    <%Html.RenderPartial("Footer", viewDic); %>
</body>
</html>
<%Html.RenderPartial("JS"); %>
<script src="/Scripts/m.hotel.com.core.min.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {
        $('#xp').on('click', 'li', function () {
            var type = $(this).attr('paytype');
            if (type == "004")
                window.location.href = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx4231803400779997&redirect_uri=http%3a%2f%2fhotel.weikeniu.com%2fWeiXinZhiFu%2fwxOAuthRedirect.aspx&response_type=code&scope=snsapi_base&state=" + $('#oid').val() + "#wechat_redirect";
            //if (type == '003') {
                //var form = $('<form></form>');
                //form.attr('method', 'post');
                //form.attr('action', '/Pay/AlipayPay');
                //var did = $('<input type="hidden" name="id"/>');
                //did.attr('value', $('#oid').val());
                //form.append(did);
                //form.css('display', 'none');
                //form.appendTo('body');
                //form.submit();
                //form.remove();
                //var hmain = document.getElementById("hmain");
                //document.getElementById("hmain").src = "/pay/AlipayPay?id=" + $('#oid').val();
                //$("#mainDiv").hide();
                //$("#iframe").show();
                //return false;
            //}
        });
    });
</script>
