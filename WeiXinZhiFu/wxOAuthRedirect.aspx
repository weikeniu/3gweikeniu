<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="wxOAuthRedirect.aspx.cs" Inherits="hotel3g.WeiXinZhiFu.wxOAuthRedirect" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>&shy;</title>
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type">
    <meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport">
    <meta name="Keywords" content="">
    <meta name="Description" content="">
    <!-- Mobile Devices Support @begin -->
    <meta content="application/xhtml+xml;charset=UTF-8" http-equiv="Content-Type">
    <meta content="no-cache,must-revalidate" http-equiv="Cache-Control">
    <meta content="no-cache" http-equiv="pragma">
    <meta content="0" http-equiv="expires">
    <meta content="telephone=no, address=no" name="format-detection">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!-- apple devices fullscreen -->
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript">
        <% if(error=="0"){ %>
            function onBridgeReady()
            {
                WeixinJSBridge.invoke('getBrandWCPayRequest',<%=wxJsApiParam%>,function (res){
                    var d="fail";
                    if(res.err_msg.indexOf("cancel")>0) {d="cancel";}   
                    if(res.err_msg.indexOf("ok")>0) {d="ok";}
                    var zhifu="<%=Zhifu %>";
                    <% if(orderid.Contains("C")){%>
                        <% if(edition.Contains("1")){%> 
                            window.location.href="/RechargeA/RechargeUser/<%=HotelID %>?key=<%=WeiXinID %>@<%=UserWeiXinID %>&OrderNO=<%=orderid %>";  
                        <%}else{ %>
                            window.location.href="/Recharge/RechargeUser/<%=HotelID %>?key=<%=WeiXinID %>@<%=UserWeiXinID %>&OrderNO=<%=orderid %>";  
                        <%}%>
                    <% }else if(orderid.Contains("P")){%>
                        <% if(edition.Contains("1")){%> 
                            window.location.href="/ProductA/ProductUserOrderDetail/<%=HotelID %>?key=<%=WeiXinID %>@<%=UserWeiXinID %>&OrderNO=<%=orderid %>";  
                        <%}else{ %>
                            window.location.href="/Product/ProductUserOrderDetail/<%=HotelID %>?key=<%=WeiXinID %>@<%=UserWeiXinID %>&OrderNO=<%=orderid %>"; 
                        <%}%>                                        
                    <%}else if(orderid.Contains("L")){ %>                    
                        <% if(edition.Contains("1")){%>  
                            window.location.href="/DishOrdera/ViewOrderDetail/<%=HotelID %>?storeId=<%=storeId %>&key=<%=WeiXinID %>@<%=UserWeiXinID %>&orderCode=<%=orderid %>";                                                     
                        <%}else{ %>
                            if(d=="ok" || zhifu!="0"){
                                window.location.href="/DishOrder/PaySuccess/<%=HotelID %>?key=<%=WeiXinID %>@<%=UserWeiXinID %>&orderCode=<%=orderid %>";                    
                            }else{
                                window.location.href="/DishOrder/PayFail/<%=HotelID %>?key=<%=WeiXinID %>@<%=UserWeiXinID %>&orderCode=<%=orderid %>";                    
                            }
                        <%}%>
                    <%}else if(orderid.Contains("D")){ %>   
                        <% if(edition.Contains("1")){%>   
                           window.location.href="/SupermarketA/OrderDetails2/<%=HotelID %>?storeId=0&orderid=<%=orderid %>&key=<%=WeiXinID %>@<%=UserWeiXinID %>";                        
                        <%}else{ %>        
                            if(d=="ok" || zhifu!="0"){
                                window.location.href="/Supermarket/OrderPay/<%=HotelID %>?key=<%=WeiXinID %>@<%=UserWeiXinID %>&orderid=<%=orderid %>";                   
                            }else{
                                window.location.href="/Supermarket/PayFail/<%=HotelID %>?key=<%=WeiXinID %>@<%=UserWeiXinID %>&orderid=<%=orderid %>";                   
                            }
                        <%}%>
                    <%} else if(orderid.Contains("K"))
                    { %>
                     <% if(edition.Contains("1")){%> 
                            window.location.href="/UserA/Index/<%=HotelID %>?key=<%=WeiXinID %>@<%=UserWeiXinID %>&OrderNO=<%=orderid %>";  
                        <%}else{ %>
                            window.location.href="/User/Index/<%=HotelID %>?key=<%=WeiXinID %>@<%=UserWeiXinID %>&OrderNO=<%=orderid %>"; 
                        <%}%>                    
                    <%}                    
                     else{ %>
                        <% if(edition=="1"){%>
                            window.location.href="/UserA/OrderInfo/<%=HotelID %>?id=<%=orderid %>&key=<%=WeiXinID %>@<%=UserWeiXinID %>";                         
                         <%}else{ %>
                            window.location.href="/User/OrderInfo/<%=HotelID %>?id=<%=orderid %>&key=<%=WeiXinID %>@<%=UserWeiXinID %>";                         
                        <%}%>
                    <%}%>    
                });            
            }
            if (typeof WeixinJSBridge == "undefined"){
                if( document.addEventListener ){
                    document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);
                }else if (document.attachEvent){
                    document.attachEvent('WeixinJSBridgeReady', onBridgeReady); 
                    document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);
                }
            }else{
                onBridgeReady();
            }
        <%} %>
    </script>
    <style type="text/css">*,body,h1,h2,h3,h4,h5,p{font-family:"Microsoft Yahei";padding:0;margin:0;font-size:14px}.icon_error{background:url(http://hotel.weikeniu.com/WeiXinZhiFu/icon.png);background-position:-66px -105px;background-size:260px 260px;width:130px;height:112px;display:block;margin:25% auto 20px}.error_p16{font-size:16px;color:#acacac;text-align:center}.btnFreshe{background:#f96268;color:#fff;border-radius:5px;width:120px;line-height:37px;border:none;font-size:15px;margin:22px auto;text-align:center}</style>
    <script type="text/javascript" src="/Scripts/jquery-1.8.0.min.js?v=20170308"></script>
</head>
<body onselectstart="return true;" ondragstart="return false;" style="-webkit-user-select: none;">
<% if(error=="1"){ %>
    <i class="icon_error"></i>
    <p class="error_p16">支付授权异常，请返回重新再试</p>
    <center><button class="btnFreshe btnGoBack" type="button">立即返回</button></center>
    <script>var type = '1', btnGoBack = $('.btnGoBack');btnGoBack.click(function () {window.history.go(-1);})</script>
<%} %>
</body>
</html>
