<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="paysuc.aspx.cs" Inherits="hotel3g.WeiXinZhiFu.paysuc" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>支付成功</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="initial-scale=1.0, width=device-width, user-scalable=no" />
    <style type="text/css">
    /* CSS RESET */
    * { padding: 0; margin: 0; }
    body {    font-family: PingFang SC,Hiragino Sans GB,Microsoft YaHei,STHeiti,WenQuanYi Micro; background: #efeff4; min-width: 320px; max-width: 640px; color: #000; }
    a { text-decoration: none; color: #666666; }
    a, img { border: none; }
    img { vertical-align: middle; }
    ul, li { list-style: none; }
    em, i { font-style: normal; }
    .clear { clear: both }
    .clear_wl:after { content: "."; height: 0; visibility: hidden; display: block; clear: both; }
    .fl { float: left }
    .fr { float: right }
    .all_w { width: 91.3%; margin: 0 auto; }
    .f10 { font-size: 10px }
    .f11 { font-size: 11px }
    .f12 { font-size: 12px }
    .f14 { font-size: 14px }
    .f13 { font-size: 13px }
    .f16 { font-size: 16px }
    .f18 { font-size: 18px }
    .f20 { font-size: 20px }
    .f22 { font-size: 22px }
    .f24 { font-size: 24px }
    .f26 { font-size: 26px }
    .f28 { font-size: 28px }
    .f32 { font-size: 32px }
    .fb { font-weight: bold }
    /********/
    .header { background: #393a3e; color: #f5f7f6; height: auto; overflow: hidden; }
    .gofh { float: left; height: 45px; display: -webkit-box; -webkit-box-orient: horizontal; -webkit-box-pack: center; -webkit-box-align: center; }
    .gofh a { padding-right: 10px; border-right: 1px solid #2e2f33; }
    .gofh a img { width: 40%; }
    .ttwenz { float: left; height: 45px; }
    .ttwenz h4 { font-size: 16px; font-weight: 400; margin-top: 2px; }
    .ttwenz h5 { font-size: 12px; font-weight: 400; color: #6c7071; }
    .wenx_xx { text-align: center; font-size: 16px; padding: 18px 0; }
    .wenx_xx .wxzf_price { font-size: 45px; }
    .skf_xinf { height: 43px; border-top: 1px solid #ddd; border-bottom: 1px solid #ddd; line-height: 43px; background: #FFF; font-size: 12px; overflow: hidden; }
    .skf_xinf .bt { color: #767676; float: left; }
    .ljzf_but { border-radius: 3px; height: 45px; line-height: 45px; background: #44bf16; display: block; text-align: center; font-size: 16px; margin-top: 14px; color: #fff; }
    /**/
    .ftc_wzsf { display:none; width: 100%; height: 100%; position: fixed; z-index: 999; top: 0; left: 0; }
    .ftc_wzsf .hbbj { width: 100%; height: 100%; position: absolute; z-index: 8; background: #000; opacity: 0.4; top: 0; left: 0; }
    .ftc_wzsf .srzfmm_box { position: absolute; z-index: 10; background: #f8f8f8; width: 88%; left: 50%; margin-left: -44%; top: 25px; }
    .qsrzfmm_bt { font-size: 16px; border-bottom: 1px solid #c9daca; overflow: hidden; }
    .qsrzfmm_bt a { display: block; width: 10%; padding: 10px 0; text-align: center; }
    .qsrzfmm_bt img.tx { width: 10%; padding: 10px 0; }
    .qsrzfmm_bt span { padding: 15px 5px; }
    .zfmmxx_shop { text-align: center; font-size: 12px; padding: 10px 0; overflow: hidden; }
    .zfmmxx_shop .mz { font-size: 14px; float: left; width: 100%; }
    .zfmmxx_shop .wxzf_price { font-size: 24px; float: left; width: 100%; }
    .blank_yh { width: 89%; margin: 0 auto; line-height: 40px; display: block; color: #636363; font-size: 16px; padding: 5px 0; overflow: hidden; border-bottom: 1px solid #e6e6e6; border-top: 1px solid #e6e6e6; }
    .blank_yh img { height: 40px; }
    .ml5 { margin-left: 5px; }
    .mm_box { width: 89%; margin: 10px auto; height: 40px; overflow: hidden; border: 1px solid #bebebe; }
    .mm_box li { border-right: 1px solid #efefef; height: 40px; float: left; width: 16.3%; background: #FFF; }
    .mm_box li.mmdd{ background:#FFF url(/WeiXinZhiFu/Public/dd_03.jpg) center no-repeat ; background-size:25%;}
    .mm_box li:last-child { border-right: none; }
    .xiaq_tb { padding: 5px 0; text-align: center; border-top: 1px solid #dadada; }
    .numb_box { position: absolute; z-index: 10; background: #f5f5f5; width: 100%; bottom: 0px; }
    .nub_ggg { border: 1px solid #dadada; overflow: hidden; border-bottom: none; }
    .nub_ggg li { width: 33.3333%; border-bottom: 1px solid #dadada; float: left; text-align: center; font-size: 22px; }
    .nub_ggg li a { display: block; color: #000; height: 50px; line-height: 50px; overflow: hidden; }
    .nub_ggg li a:active  { background: #e0e0e0;}
    .nub_ggg li a.zj_x { border-left: 1px solid #dadada; border-right: 1px solid #dadada; }
    .nub_ggg li span { display: block; color: #e0e0e0; background: #e0e0e0; height: 50px; line-height: 50px; overflow: hidden; }
    .nub_ggg li span.del img { width: 30%; }

    .fh_but{ position:absolute; right:0px; top:12px; font-size:14px; color:#20d81f;}
    .zfcg_box{ background:#f2f2f2;  height: 56px; line-height:56px;   font-size:20px; color:#1ea300; }
    .zfcg_box img{ width:10%;}

    .cgzf_info{ background:#FFF; border-top:1px solid #dfdfdd; }

    .spxx_shop{ background:#FFF; margin-left:4.35%; border-top:1px solid #dfdfdd; padding:10px 0; }
    .spxx_shop td{ color:#7b7b7b; font-size:14px; padding:10px 0;}

    .wzxfcgde_tb{ position:fixed; width:100%; z-index:999; bottom:20px; text-align:center;}
    .wzxfcgde_tb img{ width:20.6%;}
    .mlr_pm{margin-right:4.35%;}
    
    </style>
</head>
<body>
    <div class="zfcg_box " style=" display:none;">
        <div class="all_w">
            <img src="/WeiXinZhiFu/Public/cg_03.jpg">
            支付成功
        </div>
    </div>
    <div class="cgzf_info">
        <div class="wenx_xx">
            <div class="mz">
                <%=SubName %></div>
            <div class="wxzf_price">
                ￥<%=AliPayAmount%></div>
        </div>
        <div class="spxx_shop">
            <div class=" mlr_pm">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td>
                                商 品
                            </td>
                            <td align="right">
                                酒店前台支付
                            </td>
                        </tr>
                        <tr>
                            <td>
                                交易时间
                            </td>
                            <td align="right">
                                <%=Addtime%>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                支付方式
                            </td>
                            <td align="right">
                                微信支付
                            </td>
                        </tr>
                        <tr>
                            <td>
                                交易单号
                            </td>
                            <td align="right">
                                <%=TradeNo%>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="wzxfcgde_tb">
        <img src="/WeiXinZhiFu/Public/cg_07.jpg"></div>
</body>
<script type="text/javascript">
    var ua = navigator.userAgent.toLowerCase();
    var isWeixin = ua.indexOf('micromessenger') != -1;
    var isAndroid = ua.indexOf('android') != -1;
    var isIos = (ua.indexOf('iphone') != -1) || (ua.indexOf('ipad') != -1);
    if (!isWeixin) {
        document.head.innerHTML = '<title>抱歉，出错了</title><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0"><link rel="stylesheet" type="text/css" href="https://res.wx.qq.com/open/libs/weui/0.4.1/weui.css">';
        document.body.innerHTML = '<div class="weui_msg"><div class="weui_icon_area"><i class="weui_icon_info weui_icon_msg"></i></div><div class="weui_text_area"><h4 class="weui_msg_title">请在微信客户端打开链接</h4></div></div>';
    }
</script>
</html>
