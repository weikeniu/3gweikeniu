<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%
    hotel3g.PromoterEntitys.WeiXinShareConfig WeiXinShareConfig = Html.ViewData["WeiXinShareConfig"] as
        hotel3g.PromoterEntitys.WeiXinShareConfig;
    ///隐藏非基础按钮(分享按钮会被隐藏) 对于没有分享权限的公众号要开启
    bool hideAllNonBaseMenuItem = true;
    if (WeiXinShareConfig != null && !string.IsNullOrEmpty(WeiXinShareConfig.weixinid))
    {
        hotel3g.Models.DAL.JsApiSignatureResponse SignatureResponse = hotel3g.Models.DAL.WeiXinJsSdkDAL.JsApiSignature(WeiXinShareConfig.weixinid, Request.Url.AbsoluteUri);

        hotel3g.PromoterEntitys.WeiXinPublicInfoResponse WeiXinPublicInfo = hotel3g.Models.DAL.PromoterDAL.GetWeiXinPublicInfo(WeiXinShareConfig.weixinid);

        //非已分享链接
        //if (WeiXinPublicInfo != null && (WeiXinPublicInfo.weixintype == 4 || WeiXinPublicInfo.weixintype == 2))
        if (WeiXinPublicInfo != null)
        {
            hideAllNonBaseMenuItem = false;
        }

        if (string.IsNullOrEmpty(WeiXinShareConfig.title))
        {
            hideAllNonBaseMenuItem = true;
        }
        else
        {
            if (!WeiXinShareConfig.title.Contains("(分享)"))
            {
                WeiXinShareConfig.title += "(分享)";
            }
        }
       
%>
<!--微信分享-->
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>
<script type="text/javascript">

    var debug=<%=WeiXinShareConfig.debug.ToString().ToLower() %>;
    var appId='<%=SignatureResponse.appid %>';
    var timestamp='<%=SignatureResponse.timestamp %>';
    var nonceStr='<%=SignatureResponse.noncestr %>';
    var signature='<%=SignatureResponse.signature.ToLower() %>';

    wx.config({
        debug:debug, 
        appId: appId, // 必填，公众号的唯一标识
        timestamp: timestamp, // 必填，生成签名的时间戳
        nonceStr: nonceStr, // 必填，生成签名的随机串
        signature: signature, // 必填，签名，见附录1
        jsApiList: [
        'onMenuShareTimeline', 
        'onMenuShareAppMessage', 
        'hideAllNonBaseMenuItem',
        'hideMenuItems',
        'showMenuItems'] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
    });

    wx.ready(function () {

             //隐藏按钮
             wx.hideMenuItems({  
                menuList:[  
                'menuItem:share:appMessage',
                'menuItem:share:qq',  
                'menuItem:copyUrl',
                'menuItem:share:timeline',
                'menuItem:share:weiboApp',
                'menuItem:favorite"',
                'menuItem:share:facebook',
                'menuItem:share:QZone',
                'menuItem:editTag',
                'menuItem:delete',
                'menuItem:copyUrl',
                'menuItem:originPage',
                'menuItem:openWithQQBrowser',
                'menuItem:openWithSafari',
                'menuItem:share:email',
                'menuItem:share:brand',
                'menuItem:favorite'
               ]
             }); 

             <% if(!hideAllNonBaseMenuItem){%>
              wx.showMenuItems({
                  menuList: [
                   'menuItem:share:appMessage',
                   'menuItem:share:timeline',
                    'menuItem:copyUrl'
                   ]
              });
             
              wx.onMenuShareTimeline({
                  title: '<%=WeiXinShareConfig.title %>', // 分享标题
                  link: '<%=WeiXinShareConfig.sharelink %>', // 分享链接
                  imgUrl: '<%=WeiXinShareConfig.logo %>', // 分享图标
                  success: function () { 
                  // 用户确认分享后执行的回调函数
                                       },
                  cancel: function () { 
                  // 用户取消分享后执行的回调函数
                                       }
              });
             
              wx.onMenuShareAppMessage({
                  title: '<%=WeiXinShareConfig.title %>', // 分享标题
                  desc: '<%=WeiXinShareConfig.desn %>', // 分享描述
                  link: '<%=WeiXinShareConfig.sharelink %>', // 分享链接
                  imgUrl: '<%=WeiXinShareConfig.logo %>', // 分享图标
                  type: '', // 分享类型,music、video或link，不填默认为link
                  dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
                  success: function () { 
                  //用户确认分享后执行的回调函数
                                        },
                  cancel: function () { 
                  //用户取消分享后执行的回调函数
                                        }
              });
             <%}else{%>
                wx.showMenuItems({
                  menuList: [
                    'menuItem:copyUrl'
                   ]
              });
             <%} %>
           
    }); 
</script>
<%} %>