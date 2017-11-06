<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%var dt = ViewData["dt"] as System.Data.DataTable;
  string userweixin = ViewData["userweixin"].ToString();
  string weixinid = ViewData["weixinid"].ToString();
  string hotelid = ViewData["hotelid"].ToString();
  string Frequency = "";
  string activityid = "";
  if (dt.Rows.Count > 0)
  {
      activityid = dt.Rows[0]["ActivityID"].ToString();
      Frequency = dt.Rows[0]["Frequency"].ToString();
  }
  ViewDataDictionary viewDic = new ViewDataDictionary();
  viewDic.Add("weixinID", weixinid);
  viewDic.Add("hId", hotelid);
  viewDic.Add("uwx", userweixin);
  
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head id="Head1">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width,minimum-scale=1,user-scalable=no,maximum-scale=1,initial-scale=1" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="format-detection" content="telephone=no" />
    <meta name="description" content="微可牛" />
    <link href="http://css.weikeniu.com/css/booklist/sale-date.css?v=1.0" rel="stylesheet" type="text/css" />
    <link href="../../css/dazhuanpan/ZPalertify.css" rel="stylesheet" type="text/css" />
    <link href="../../css/dazhuanpan/ZPjquery.css" rel="stylesheet" type="text/css" />
    <link href="../../css/dazhuanpan/ZPcommon.css" rel="stylesheet" type="text/css" />
    <link href="../../css/css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .cover
        {
            width: 100%;
            max-width: 320px;
            margin: 0 auto;
            position: relative;
        }
        .cover img
        {
            width: 100%;
        }
        #outer-cont
        {
            position: absolute;
            width: 100%;
            top: 20px; /* -moz-transform: rotate(-5deg);
	        -webkit-transform: rotate(-5deg);
	        -o-transform: rotate(-5deg);
	        -ms-transform: rotate(-5deg);
	        transform: rotate(-5deg); */
        }
        #inner-cont
        {
            position: absolute;
            width: 100%;
            top: 90px; /* -moz-transform: rotate(-5deg);
	        -webkit-transform: rotate(-5deg);
	        -o-transform: rotate(-5deg);
	        -ms-transform: rotate(-5deg);
	        transform: rotate(-5deg); */
        }
        #outer
        {
            width: 300px;
            max-width: 300px;
            height: 300px;
            margin: 0 auto;
        }
        #inner
        {
            width: 112px;
            max-width: 112px;
            height: 142px;
            margin: 0 auto;
            cursor: pointer;
        }
        #outer img, #inner img
        {
            display: block;
            margin: 0 auto;
        }
        .content
        {
            margin-top: 20px;
            padding: 0 15px;
        }
        .content .desc
        {
            font-weight: bold;
            border-bottom: 1px dashed #000;
            padding: 12px 0px;
        }
        .loading-mask
        {
            width: 100%;
            height: 100%;
            position: fixed;
            background: rgba(0,0,0,0.6);
            z-index: 100;
            left: 0px;
            top: 0px;
        }
        
        .comfin
        {
            background: #4ea20b;
            width: 100%;
            font-size: 16px;
            color: #fff;
            line-height: 40px;
            height: 40px;
            font-weight: lighter;
            text-align: center;
            display: block;
            border-radius: 10px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
            text-decoration: blink;
            margin-top: 10px;
        }
    </style>
    <title>幸运大转盘抽奖</title>
    <script src="../../Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
    <script src="../../Scripts/ZPmobile.js" type="text/javascript"></script>
    <%Html.RenderPartial("JSHeader"); %>
</head>
<body style="min-height: 618px;">
    <div id="panelLottery">
        <div class="cover">
            <img src="../../css/images/ZPmobile_bg1.jpg" width="480" height="350" alt="" />
        </div>
        <div id="outer-cont">
            <div id="outer">
                <%if (dt.Rows.Count < 9)
                  { %>
                <img src="../../css/images/pan3.png" alt="" />
                <%}
                  else
                  { %>
                <img src="../../css/images/dazhaungpannew.png#222" alt="" style="width: 100%; margin-top: 5px;" />
                <%} %>
            </div>
        </div>
        <div id="inner-cont">
            <div id="inner">
                <img src="../../css/images/ZPpan-2.png" /></div>
        </div>
        <div id="msgss">
        </div>
        <div class="content">
            <p class="desc">
                活动说明<br />
                <%--<span style="color: red;">
                    <%="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dt.Rows[0]["Descripe"].ToString().Replace("优惠券", "订房红包")%></span>--%>
                    <span style="color: red;">
                    <%="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dt.Rows[0]["Descripe"].ToString() %></span>
                    </p>
        </div>
    </div>
    <!--弹出框-->
    <div id="promptMsg" class="ui-dialog-contain ui-corner-all ui-overlay-shadow" style="display: none">
        <div class="ui-corner-top ui-header ui-bar-d">
            <a title="Close" class="ui-btn-left ui-btn ui-shadow ui-btn-corner-all ui-btn-icon-notext ui-btn-up-d"
                href="javascript:void(0);"><span class="ui-btn-inner ui-btn-corner-all"><span class="ui-btn-text">
                    Close</span> <span class="ui-icon ui-icon-delete ui-icon-shadow">&nbsp;</span>
                </span></a>
            <h3 class="ui-title">
                恭喜你！中奖了</h3>
        </div>
        <div class="ui-corner-bottom ui-content ui-body-c">
            <p style="font-weight: bold;">
                你中的是<span id="prizetype"></span>，为了您更好的获取奖品,请点击<a href="/User/Index/<%=hotelid %>?key=<%=weixinid %>@<%=userweixin %>">【个人中心】</a>完善您的个人信息!
            </p>
            <a class="comfin" href="/User/MyReWard/<%=hotelid %>?key=<%=weixinid %>@<%=userweixin %>">
                确定</a>
        </div>
    </div>
    <section id="alertEle" class="alertify-dialog is-alertify-dialog-showing" style="display: none;">
        <div class="alertify-dialog-inner">
            <article class="alertify-inner">
                <p class="alertify-message" id="alertEleMsg"></p>
                    <nav class="alertify-buttons">
                        <button id="alertify-ok" class="alertify-button alertify-button-ok" type="button" role="button" onclick="$('#alertEle').css('display','none');">确定</button>
                     </nav>
             </article><a href="#" class="alertify-resetFocus" id="alertify-resetFocus">Reset Focus</a></div></section>
    <!--footer-->
    <div style="clear: both;">
    </div>
    <%Html.RenderPartial("Copyright"); %>
    <%Html.RenderPartial("Footer", viewDic); %>
</body>
</html>
<%Html.RenderPartial("JS"); %>
<script type="text/javascript">
    var IsThank;
    var IsError;
    var IsWin;
    var PrizeId;
    var Errorid;
    var FromUserName = "";
    var Rotate = {};


    Rotate.init = function () {
        Rotate.speed = 6; //转速
        Rotate.prizeList = { 'i109': '一等奖', 'i110': '二等奖', 'i111': '三等奖', 'i112': '谢谢参与', 'i113': '不要灰心', 'i114': '要加油哦', 'i115': '运气先攒着', 'i116': '再接再厉', 'i117': '祝你好运', 'i214': '四等奖', 'i215': '五等奖', 'i216': '六等奖', 'i217': '七等奖', 'i218': '八等奖','i219':'免单' };
        Rotate.isRun = false;
        Rotate.isStop = false;
        Rotate.isFaild = false;
    };
    Rotate.getPrizeDeg = function (prizeid) {
 
        if (Rotate.prizeList['i' + prizeid]) {
       
        <% if(dt.Rows.Count < 10) { %>
            if (Rotate.prizeList['i' + prizeid] == '一等奖') return 8;
            if (Rotate.prizeList['i' + prizeid] == '二等奖') return 248;
            if (Rotate.prizeList['i' + prizeid] == '三等奖') return 128;
            if (Rotate.prizeList['i' + prizeid] == '谢谢参与') return 336;
            if (Rotate.prizeList['i' + prizeid] == '不要灰心') return 36;
            if (Rotate.prizeList['i' + prizeid] == '要加油哦') return 276;
            if (Rotate.prizeList['i' + prizeid] == '运气先攒着') return 216;
            if (Rotate.prizeList['i' + prizeid] == '再接再厉') return 156;
            if (Rotate.prizeList['i' + prizeid] == '祝你好运') return 96;
         <%}else{ %>
            //八奖项
            if (Rotate.prizeList['i' + prizeid] == '一等奖') return 1;
            if (Rotate.prizeList['i' + prizeid] == '免单') return 84;
            if (Rotate.prizeList['i' + prizeid] == '二等奖') return 236;
            if (Rotate.prizeList['i' + prizeid] == '三等奖') return 116;
            if (Rotate.prizeList['i' + prizeid] == '四等奖') return 324;
            if (Rotate.prizeList['i' + prizeid] == '谢谢参与') return 24;
            if (Rotate.prizeList['i' + prizeid] == '五等奖') return 264;
            if (Rotate.prizeList['i' + prizeid] == '六等奖') return 200;
            if (Rotate.prizeList['i' + prizeid] == '七等奖') return 144;
            if (Rotate.prizeList['i' + prizeid] == '八等奖') return 52;
            <%} %>
        }
        <% if(dt.Rows.Count < 10) { %>
        return 160;
        <%}else{%>
        return 24;
        <%} %>
    }
    Rotate.run = function () {
        Rotate.init();
        Rotate.isRun = true;
        var deg = 0;
        var deg_increment = 18;
        var runCount = 0;

        //开始旋转
        Rotate.getWinResult();
        //获取摇奖结果
        setTimeout(ratateing, Rotate.speed);

        function ratateing() {
           
            deg += deg_increment;
            Rotate.rotateY('#outer', deg);
            if (deg == 360) {
                deg = 0;
                deg_increment = 12;
                if (runCount > 3) {
                    deg_increment = 4;
                }
                runCount++;
            }
            if (runCount < 4 || !Rotate.isStop) {
                setTimeout(ratateing, Rotate.speed);
                return;
            }
            //检测中奖情况
            checkWin();
        }
        //判断中奖情况
        function checkWin() {
            if (IsWin) {//中奖
                if (Rotate.getPrizeDeg(PrizeId) == deg) {
                    setTimeout(function () {
                        Rotate.showPrompt();
                        Rotate.isRun = false;
                    }, 2000);
                    return;
                }
            }
            if (IsThank) {//鼓励奖
                if (Rotate.getPrizeDeg(PrizeId) == deg) {
                    setTimeout(function () {
                        Rotate.isRun = false;
                        if (IsError) {//内部服务器错误                    
                            if (Errorid == "-100") {
                                alert_t('您的抽奖次数已经用完');
                            }
                            else if (Errorid == "-101") {
                                alert_t('对不起，您的活动次数已到限制');
                            }
                            else if (Errorid == "-104") {
                                alert_t('对不起，现在没有活动');
                            }
                            else if (Errorid == "-401") {
                                alert_t('对不起，活动已经结束');
                            }
                            else {
                                alert_t('对不起，网络连接错误，请重试');
                            }
                            Rotate.isRun = false;
                            return;
                        }
                        else {


                            alert_t('对不起，您这次没有中奖');



                            //    alert_t('对不起，您这次没有中奖');
                        }
                    }, 1000);
                    return;
                }

            }
            //继续选装
            setTimeout(ratateing, Rotate.speed);
        }
    };
    Rotate.showPrompt = function () {
        $('#prizetype').html(Rotate.prizeList['i' + PrizeId]);
        $('#promptMsg').css("display", "block");
        $('#panelLottery').css("display", "none");
    };
    //向服务器请求抽奖
    Rotate.getWinResult = function () {
        var config = {
            method: 'get',
            url: '/user/checkdazhuanpan?r=' + Math.random() + '&FromUserName=<%=userweixin %>&activityid=<%=activityid %>&weixinid=<%=weixinid %>&frequency=<%=Frequency %>'
        };

        var request = new x.WebRequest(config);

        request.onSuccess = function (responseText, responseXML) {
            var jsonobj = eval('(' + responseText + ')');
            IsThank = jsonobj.IsThank;
            IsError = jsonobj.IsError;
            IsWin = jsonobj.IsWin;
            PrizeId = jsonobj.PrizeId;
            Errorid = jsonobj.ErrorId;
            Rotate.isFaild = false;
            Rotate.isStop = true;
        };

        request.onFailure = function () {
            Rotate.isFaild = true;
            Rotate.isStop = true;
        };

        request.onException = function () {
            Rotate.isFaild = true;
            Rotate.isStop = true;
        };

        request.send(null);
    };

    Rotate.rotateY = function (id, _deg) {
        var element = $(id);

        element.css('MozTransform', 'rotateZ(' + _deg + 'deg)');
        element.css('WebkitTransform', 'rotateZ(' + _deg + 'deg)');
        element.css('OTransform', 'rotateZ(' + _deg + 'deg)');
        element.css('MsTransform', 'rotateZ(' + _deg + 'deg)');
        element.css('Transform', 'rotateZ(' + _deg + 'deg)');
    };

    $("#inner").click(function () {
        if (Rotate.isRun) {
            return;
        }
        Rotate.run();
    });

    function alert_t(msg) {
        $('#alertEleMsg').html(msg);
        $("#alertEle").css("display", "block");
    };
</script>
