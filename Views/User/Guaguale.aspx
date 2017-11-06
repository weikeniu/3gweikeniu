<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%var dt = ViewData["dt"] as System.Data.DataTable;
  string userweixin = ViewData["userweixin"].ToString();
  string weixinid = ViewData["weixinid"].ToString();
  string Frequency = "";
  string activityid = "";
  string id = RouteData.Values["id"].ToString();

  if (dt.Rows.Count > 0)
  {
      activityid = dt.Rows[0]["ActivityID"].ToString();
      Frequency = dt.Rows[0]["Frequency"].ToString();
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width,minimum-scale=1,user-scalable=no,maximum-scale=1,initial-scale=1" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="format-detection" content="telephone=no" />
    <link href="../../css/guagua/common2.css" rel="stylesheet" type="text/css" />
    <link href="../../css/guagua/jquery.css" rel="stylesheet" type="text/css" />
    <link href="../../css/guagua/alertify.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .cover
        {
            width: 320px;
            max-width: 480px;
            margin: 0 auto;
            position: relative;
        }
        .cover img
        {
            width: 320px;
        }
        #scratchpad, #prize, #winresult
        {
            position: absolute;
            width: 150px;
            height: 40px;
            top: 110px;
            right: 50px;
            text-align: center;
            font-weight: bold;
            font-size: 20px;
            line-height: 40px;
        }
        .btn-cont
        {
            position: absolute;
            bottom: -9px;
            right: 3px;
            display: none;
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
        p
        {
            margin: 0 0 10px;
            font-size: 14px;
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
    <title>刮刮卡抽奖页面 </title>
    <script type="application/x-javascript">addEventListener('load',function(){setTimeout(function(){scrollTo(0,1);},0);},false);</script>
</head>
<%Html.RenderPartial("JS"); %>
<body>
    <div id="panelLottery">
        <div class="cover">
            <%-- <img src="../images/mobile_bg3.jpg" height="208px">--%>
            <img src="/css/images/guagua-01-bg.jpg" height="195px" />
            <div id="prize">
            </div>
            <div id="winresult">
                <div style="position: relative; width: 150px; height: 40px; cursor: default;">
                    <div id="winPrize" width="150" height="40" style="cursor: default;">
                    </div>
                </div>
            </div>
            <div id="scratchpad">
                <div id="canvaspanel" style="position: relative; width: 150px; height: 40px; cursor: default;">
                    <canvas id="canvas" width="150" height="40" style="cursor: default;"></canvas>
                </div>
            </div>
            <div style="display: block;" class="btn-cont" onclick="getPrize();">
                <a class="ui-btn ui-shadow ui-btn-corner-all ui-btn-up-c" data-theme="c" data-wrapperels="span"
                    data-iconshadow="true" data-shadow="true" data-corners="true" href="javascript:;"
                    id="opendialog" data-role="button" data-rel="dialog"><span class="ui-btn-inner ui-btn-corner-all">
                        <span class="ui-btn-text">我要领奖</span></span></a>
            </div>
        </div>
        <div class="content">
            <p class="desc">
                活动说明：<br />
                <span style="color: red;">
                    <%="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dt.Rows[0]["Descripe"]%></span></p>
            <p>
                一等奖：<span id="first"><%=dt.Rows[0]["PrizeName"].ToString().Replace("优惠券", "订房红包")%></span></p>
            <p>
                二等奖：<span id="sencond"><%=dt.Rows[1]["PrizeName"].ToString().Replace("优惠券", "订房红包")%></span></p>
            <p>
                三等奖：<span id="third"><%=dt.Rows[2]["PrizeName"].ToString().Replace("优惠券", "订房红包")%></span></p>
            <%if (dt.Rows[3]["PrizeName"].ToString() != "谢谢参与")
              { %>
            <p>
                参与奖：
                <%= dt.Rows[3]["PrizeName"].ToString().Replace("优惠券", "订房红包")%></p>
            <%} %>
        </div>
    </div>
    <!--弹出框-->
    <div id="promptMsg" class="ui-dialog-contain ui-corner-all ui-overlay-shadow" style="display: none">
        <div class="ui-corner-top ui-header ui-bar-d">
            <a title="Close" class="ui-btn-left ui-btn ui-shadow ui-btn-corner-all ui-btn-icon-notext ui-btn-up-d"
                href="#"><span class="ui-btn-inner ui-btn-corner-all"><span class="ui-btn-text">Close</span>
                    <span class="ui-icon ui-icon-delete ui-icon-shadow">&nbsp;</span> </span>
            </a>
            <h3 class="ui-title">
                恭喜你！中奖了</h3>
        </div>
        <div class="ui-corner-bottom ui-content ui-body-c">
            <p id="ts" style="font-weight: bold;">
                你中的是【<span id="winjiang"></span>】，为了您更好的获取奖品,请点击<a href="/User/Index/<%=id %>?weixinID=<%=weixinid %>">【个人中心】</a>完善您的个人信息!</p>
            <a class="comfin" href="/User/MyReWard/<%=id %>?key=<%=weixinid %>@<%=userweixin %>">
                确定</a>
        </div>
    </div>
    <section id="alertEle" class="alertify-dialog is-alertify-dialog-showing" style="display: none;">
        <div class="alertify-dialog-inner">
            <article class="alertify-inner">
                <p class="alertify-message" id="alertEleMsg"></p>
                    <nav class="alertify-buttons">
                        <button id="alertify-ok" class="alertify-button alertify-button-ok" type="button" role="button" onclick="$gel('alertEle').style.display='none';">确定</button>
                     </nav>
             </article><a href="#" class="alertify-resetFocus" id="alertify-resetFocus">Reset Focus</a></div></section>
    <div style="clear: both;">
    </div>
    <p class="page-url">
        <a href="#" target="_blank" class="page-url-link">此功能由"微可牛"平台提供</a>
    </p>
</body>
</html>
<script src="/Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
<script src="/Scripts/mobile.js" type="text/javascript"></script>
<script type="text/javascript">
    var c = document.getElementById("canvas");
    var ctx = c.getContext("2d");
    ctx.fillStyle = "#CCCCCC";
    ctx.fillRect(0, 0, 150, 40);
    var isGua = false; //是否已经刮奖
    var FromUserName = "osASjjqX0YzS1jYAKWVCsgLxOjvt111";
    (function () {
        var paint = {
            init: function () {
                this.load();
            },
            load: function () {
                this.x = []; //记录鼠标移动是的X坐标
                this.y = []; //记录鼠标移动是的Y坐标
                this.clickDrag = [];
                this.lock = false; //鼠标移动前，判断鼠标是否按下
                this.isEraser = true;
                this.eraserRadius = 8; //擦除半径值  
                this.$gel = function (id) { return typeof id == "string" ? document.getElementById(id) : id; };
                this.canvas = this.$gel("canvas");
                if (this.canvas.getContext) {
                } else {
                    alert("您的浏览器不支持 canvas 标签");
                    return;
                }
                this.cxt = this.canvas.getContext('2d');
                this.touch = ("createTouch" in document); //判定是否为手持设备
                this.StartEvent = this.touch ? "touchstart" : "mousedown"; //支持触摸式使用相应的事件替代
                this.MoveEvent = this.touch ? "touchmove" : "mousemove";
                this.EndEvent = this.touch ? "touchend" : "mouseup";
                this.bind();
            },
            bind: function () {
                var t = this;
                /*鼠标按下事件，记录鼠标位置，并绘制，解锁lock，打开mousemove事件*/
                this.canvas['on' + t.StartEvent] = function (e) {
                    //check();
                    var touch = t.touch ? e.touches[0] : e;
                    position = x.getAbsoluteLocation('canvas');
                    var _x = touch.clientX - position.left; //鼠标在画布上的x坐标，以画布左上角为起点
                    var _y = touch.clientY - position.top; //鼠标在画布上的y坐标，以画布左上角为起点 
                    t.resetEraser(_x, _y);
                    t.lock = true;
                };
                /*鼠标移动事件*/
                this.canvas['on' + t.MoveEvent] = function (e) {
                    var touch = t.touch ? e.touches[0] : e;
                    if (t.lock)//t.lock为true则执行
                    {
                        position = x.getAbsoluteLocation('canvas');
                        var _x = touch.clientX - position.left; //鼠标在画布上的x坐标，以画布左上角为起点
                        var _y = touch.clientY - position.top; //鼠标在画布上的y坐标，以画布左上角为起点 
                        t.resetEraser(_x, _y);
                    }
                };
                this.canvas['on' + t.EndEvent] = function (e) {
                    /*重置数据*/
                    t.lock = false;
                    t.x = [];
                    t.y = [];
                    t.clickDrag = [];
                    clearInterval(t.Timer);
                    t.Timer = null;
                };
            },
            resetEraser: function (_x, _y) {
                /*使用橡皮擦-提醒*/
                var t = this;
                //this.cxt.lineWidth = 30;
                /*source-over 默认,相交部分由后绘制图形的填充(颜色,渐变,纹理)覆盖,全部浏览器通过*/
                t.cxt.globalCompositeOperation = "destination-out";
                t.cxt.beginPath();
                t.cxt.arc(_x, _y, t.eraserRadius, 0, Math.PI * 1);
                t.cxt.strokeStyle = "rgba(250,250,250,0)";
                t.cxt.fill();
                t.cxt.globalCompositeOperation = "source-over"
                //alert('1');
                //                    if (!check()) {
                //                        window.location.href = "/user/index";
                //                    }
                //check();
                if (!isGua) {

                    isGua = true;
                    result();
                }

            }


        };
        paint.init();
    })();

    function getPrize() {
        var IsWin = "True";
        if (!isGua) {
            alert('请将刮奖区域刮开');
            return;
        }
        if ($gel('winjiang').innerHTML != "谢谢参与" && $gel('winjiang').innerHTML != "") {
            IsWin = "True";
        }
        else {
            IsWin = "False";
        }
        if (IsWin == "True") {
            $gel('promptMsg').style.display = 'block';
            $gel('panelLottery').style.display = 'none';
        }
        else {
            alert('您本次没有中奖');
            location.reload();
        }
    }

    //        function getPrize() {
    //            //check();result;

    //            var IsWin = "True";
    //            if (!isGua) {
    //                alert('请将刮奖区域刮开');
    //                return;
    //            }
    //            if (IsWin == "True") {
    //                $gel('promptMsg').style.display = 'block';
    //                $gel('panelLottery').style.display = 'none';
    //            }
    //            else {
    //                alert('您本次没有中奖');
    //                location.reload();
    //            }
    //        }
    function alert_t(msg) {
        $gel('alertEleMsg').innerHTML = msg;
        $gel('alertEle').style.display = 'block';
    };

    function result() {
        $.post("/user/Properprize", { "FromUserName": "<%=userweixin %>", "weixinid": "<%=weixinid %>", "activityid": "<%=activityid %>" }, function (data) {

            if (data == "101") {
                $gel('winPrize').innerHTML = "一等奖";
                $gel("winjiang").innerHTML = $gel('winPrize').innerHTML;

            }
            else if (data == "102") {
                $gel('winPrize').innerHTML = "二等奖";
                $gel("winjiang").innerHTML = $gel('winPrize').innerHTML;

            }
            else if (data == "103") {
                $gel('winPrize').innerHTML = "三等奖";
                $gel("winjiang").innerHTML = $gel('winPrize').innerHTML;

            }
            else if (data == "104") {
                $gel('winPrize').innerHTML = "谢谢参与";
                $gel("winjiang").innerHTML = $gel('winPrize').innerHTML;
            }
            else if (data == "105") {
                alert("抽奖次数已经用完");
                return false;
            }
        });
    }
      

</script>
