<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pay.aspx.cs" Inherits="hotel3g.WeiXinZhiFu.pay" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>&shy;</title><meta content="text/html; charset=utf-8" http-equiv="Content-Type" /><meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" /><meta name="Keywords" /><meta name="Description" />
    <meta content="application/xhtml+xml;charset=UTF-8" http-equiv="Content-Type" /><meta content="no-cache,must-revalidate" http-equiv="Cache-Control" /><meta content="no-cache" http-equiv="pragma" /><meta content="0" http-equiv="expires" /><meta content="telephone=no, address=no" name="format-detection" /><meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
    <script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <style type="text/css">
        *,body,h1,h2,h3,h4,h5,p{font-family:"Microsoft Yahei";padding:0;margin:0;font-size:14px}
        .icon_error{background-position:-66px -105px;background-size:260px 260px;width:130px;height:112px;display:block;margin:25% auto 20px}
        .error_p16{font-size:16px;color:#acacac;text-align:center}.btnFreshe{background:#12b7f5;color:#fff;border-radius:5px;width:120px;line-height:37px;border:none;font-size:15px;margin:22px auto;text-align:center}
        .item-select-list{position:relative; padding:15px;border-width:0 0 1px 0;border-left: 2px solid transparent; background-color:#fff;overflow:hidden;font-size:15px;}
        .item-select-list.item-seleced{border-left:2px solid #00aee2;border-image: none;-webkit-border-image:none;}
        .item-select-list .item-code{float:left;width:65px;}
        .item-select-list .item-cont{margin-left:65px;}
        .item-select-list .payDept-hotel{display:inline-block;margin-top:3px;color:#999;font-size:12px;}
        .item-select-list.item-seleced .item-code,
        .item-select-list.item-seleced .name-hotel{color:#00aee2;}     
        .sta-result-no{margin:50px 0; text-align:center; color:#666; text-shadow:0 1px 0 #fff;}
        .sta-fix-bottom{position:fixed; bottom:0; z-index:99; margin:0;}
        .sta-fix-top{position:fixed; top:0; z-index:99; margin:0;}
        .container{margin-top:44px; overflow:hidden;}
        input[disabled]+.label-t{color:#ccc;}       
        .header{background-color:#00aee2; height:44px; line-height:34px; text-align:center; color:#fff; padding:5px; border-top:0px solid #066f9c; width:100%; box-sizing:border-box; overflow:hidden; position:relative;  font-size:1.286em;}
        .header p{text-overflow:ellipsis; white-space:nowrap; overflow:hidden;}
        .header-r,.header-l{position:absolute; top:0;}
        .header-l{left:0;}
        .header-r{right:0;}
        .header .header-title{line-height:1.2;}
        .header .header-title .header-title-sub{font-size:14px;opacity:.7}     
        .sta-fix-top {position: fixed;top: 0;z-index: 99;margin: 0;}  
        .e-1pxbd{border-style:solid;border-color:#ddd;border-image:url(ddata:image/gif;base64,R0lGODlhBQAFAIABAN3d3f///yH5BAEAAAEALAAAAAAFAAUAAAIHhB9pGatnCgA7) 2 stretch;-webkit-border-image:url(data:image/gif;base64,R0lGODlhBQAFAIABAN3d3f///yH5BAEAAAEALAAAAAAFAAUAAAIHhB9pGatnCgA7) 2 stretch;}                           
        body,dl,dd,ul,ol,h1,h2,h3,h4,h5,h6,pre,form,fieldset,legend,input,textarea,p,blockquote,figure,hr,menu,dir,thead,tbody,tfoot,th,td{margin:0;padding:0;}
        * {box-sizing: border-box;-webkit-box-sizing: border-box;-moz-box-sizing: border-box;-o-box-sizing: border-box;}
        ol,ul{list-style:none;}
        a{text-decoration:none;}
        a:active,a:hover{outline:0 none;}
        a:focus{outline:1px dotted;}
        html{-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%;text-size-adjust:100%;font-size:62.5%;-webkit-tap-highlight-color: rgba(0,0,0,0);}
        body,html{height: 100%;}
        body{background-color:#F8F8F8;font:normal 12px/1.5 "helvetica neue", helvetica, STHeiTi, roboto, "droid sans",\5FAE\8F6F\96C5\9ED1, arial; -webkit-font-smoothing:antialiased;color:#333;  -webkit-overflow-scrolling: touch;}
        h1,h2,h3,h4,h5,h6{font-size:100%;font-weight:normal;}             
    </style>
    <script type="text/javascript" src="/Scripts/jquery-1.8.0.min.js?v=20170308"></script>
</head>
<body onselectstart="return true;" ondragstart="return false;" style="-webkit-user-select: none;">    
    <% if (hmanege.Count > 1){%>
    <div>
        <header id="headerSearchContainer" class="header sta-fix-top">                
            选择当前门店
            <div class="header-r" id="sConfirm">
                <span class="hotels-cont"></span>
            </div>
        </header>
        <div class="container">
            <section class="sec-select-hotels" id="HotelContainer">
                <ul class="ui-hotels-list  audit-hotel-filter" id="allHotelsContainer" style="display: none;">
                    <li class="item-select-list ac-selectAll e-1pxbd">
                        <span class="item-code">全部分店</span>
                        <div class="in-box" id="allHotel"><span>&nbsp;</span></div>
                    </li>
                </ul>
                <ul id="hotellist" class="ui-hotels-list">
                    <% foreach (KeyValuePair<string, string> kvp in hmanege)
                       { %>
                    <li class="item-select-list e-1pxbd" id="<%=kvp.Key %>"><a href="https://open.weixin.qq.com/connect/oauth2/authorize?appid=<%=appid %>&redirect_uri=http%3a%2f%2fhotel.weikeniu.com%2fWeiXinZhiFu%2fFastcollection.aspx&response_type=code&scope=snsapi_base&state=<%=kvp.Key %>|<%=type %>#wechat_redirect" style="font-size: 12px; color: #323131;"><span class="item-code"><%=kvp.Key %></span><div class="item-cont"><h6 class="name-hotel"><%=kvp.Value%></h6><span class="payDept-hotel"></span></div></a></li>                    
                    <%} %>
                </ul>
            </section>
        </div>
    </div>
    <%}else{ %> 
    <div style=" display:;">
        <i class="icon_error"></i>
        <p class="error_p16">支付授权异常，请返回重新再试</p>
        <center><button class="btnFreshe btnGoBack" type="button">立即返回</button></center>
        <script>var type = '1', btnGoBack = $('.btnGoBack'); btnGoBack.click(function () { window.history.go(-1); })</script>
    </div>
    <%} %>
</body>
</html>