<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
    <title>XXX发放随即红包啦,快去碰碰运气</title>

    <link href="../../Content/css/weixincoupon.css" rel="stylesheet" type="text/css" />
    <style>
    .list{width:90%;margin:0px auto;text-align:left;}
    .img{width:40px;height:40px;border-radius:20px;}
    .name{font-weight:bold;font-size:1em}
    .time{font-size:1.0em;color:#777}
    .it{font-size:1.5em;color:#555}
    .phonecode{width:90%;margin-bottom:0px;margin:0px auto;color:#fff}
    .phonecode div{text-align:left;font-size:6.0em;position:relative;margin-bottom:10px}
    .phone,.code{border:none;vertical-align:middle;outline:none;text-indent:7px;font:20px/35px microsoft yahei,simhei;}
    .phone{width:100%;}
    .code{width:50%;}
    .sendchart{width:45%;border:none;;border:none;right:0;float:right;background:#f80;color:#fff;cursor:pointer;font:20px/35px microsoft yahei,simhei;}
    </style>
</head>
<body>

    <div class="main">
    <div  id="result" style="display:none;width:300px;height:100px;position:fixed;background:url('../../Content/pic/bg.jpg') no-repeat;background-size:100% 100%;top:50%;margin-top:-50px;left:50%;margin-left:-150px;z-index:10">
     <div style="color:#fff;text-align:center;line-height:100px;font-size:20px;font-weight:bold;"></div>
</div>

    <img class="banner" src="http://p0.meituan.net/xianfu/4a91b5d49bbd7e0c34bb1e438d8f137863488.png" alt="">

    <div class="line" id="ct">
<script src="../../Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
<script src="../../Scripts/weixincoupon123.js" type="text/javascript"></script>



<form action="Verification" method="post" id="ation">
<% bool NotReceive = (bool)ViewData["NotReceive"]; 
    string[] IDS = Request.QueryString["state"].Split('@');%>

    <%if (!NotReceive && (bool)ViewData["CouPonIsExists"])
      { %>
      <%if (Session["GetBonusStatus"] != null && Session["GetBonusStatus"] != "0" && Session["GetBonusStatus"] != "3")
        {
           
        %>

        <%=IDS[0]==""||IDS[1]==""?"":Session["GetBonusStatus"]%>

        <%
        }
        else
        { %>
     <font color="#ddd">您已领取过该红包</font>
    
    <%}
      }

        if (IDS[0] != "" && IDS[1] != "" && NotReceive && (bool)ViewData["CouPonIsExists"])
      { %>
     <input type="hidden" name="key" value="<%=Request.QueryString["key"] %>" />
     <div class="phonecode">
     <div><input class="phone" name="phone" placeholder="请输入您的手机号"  /></div>
     <div><input class="code"  name="code" placeholder="请输入验证码" /><input class="sendchart" type="button" value="发送短信" /></div>
     </div>
     <input type="button" value="碰碰手气" id="random" />
    <% } %>
   
 </form>

 <%if ((Session["GetBonusStatus"] != null && (Session["GetBonusStatus"] == "0" || Session["GetBonusStatus"] == "3")) || Request.QueryString["key"].Split('@').Length != 2 || Request.QueryString["key"].Split('@')[1] == "" || !(bool)ViewData["CouPonIsExists"])
   { %>
   <div style="background:url(http://xs01.meituan.net/waimai_c_api_i/img/resource/red-enve2/result-bg.f9797470.png) no-repeat;background-size:100% 100%;width:90%;height:200px;margin:0px auto;line-height:200px;color:#818181;font-size:4em;font-weight:bold">已过期</div>
 <%} %>

    </div>

    <div class="line"><span id="msg" style="color:#fff;font-size:16px;"></span></div>
    <div class="line">
    <section class="rule">
    <h4 class="sec-sub-title">活动规则</h4>
    <ul>
        <li>1.红包新老用户同享</li>
        <li>2.红包可与其他优惠叠加使用，首单支付红包不可叠加</li>
        <li>3.红包仅限在美团外卖最新版客户端下单且选择在线支付时使用</li>
        <li>4.使用红包时下单手机号码必须为抢红包时手机号码</li>
        <li>5.本活动最终解释权归美团外卖所有</li>
        <li>6.红包使用说明，<a id="toggle-help" class="toggle-help" href="javascript:;">点击了解&gt;</a></li>
    </ul>

    <h4 class="sec-sub-title">其他人手气</h4>
    
    <table class="list">
    <% List<hotel3g.Models.UserWeiXin> List = ViewData["ReceiveUsers"] as List<hotel3g.Models.UserWeiXin>; %>
    
    <%for (int i = 0; i < List.Count; i++) {var item=List[i]; %>
    
    <tr><td class="img"><img class="img" src="<%:item.HeadImgUrl.Replace("\"","") %>" /></td><td><%="<span class=name>"+item.NickName.Replace("\"","")+"</span>" %> <%="<span class=time>"+item.AddTime+"</span>" %><br /><span class="it">红包的金额和你的颜值一样高哦!</span></td><td><%:item.Price %>元</td></tr>
    <%} %>

    </table>

  </section>

  <section>

  <table class="list">
 
  </table>
  <input id="codeNumber" />
  </section>
    </div>
    </div>
   

</body>
</html>

<script>
    $(document).ready(function () {

        $("#random").click(function () {

            var number = $(".phone").val();
            var code = $(".code").val();
            var codeNumber = $("#codeNumber").val();
            alert(codeNumber);
            if (number != "" && code != "") {
                if (codeNumber != "") {
                    var data = eval($("#codeNumber").val());
                    var zphone = data[0].phone;
                    var zcode = data[0].code;
                    if (zphone == number && zcode == code) {
                        $("#random").attr("disabled", "disabled");
                        $("#ation").submit();
                    } else {
                        alert("验证码有误");
                    }
                } else { alert("请获取验证码!"); }
            } else {
                alert("数据未填写")
            }


        });

        $(".sendchart").click(function () {
            var ct = $(this);
            //校验手机号码格式
            var rez = /^((0\d{2,3}-\d{7,8})|(1[3584]\d{9}))$/;
            var phone = new RegExp(rez);
            var number = $(".phone").val();
            if (!phone.test(number)) {
                alert("手机号码格式不正确!");
            } else {
                //发送短信
                timego(ct);
                //异步发送短信
                $.post("../../../Content/api/SendChart.ashx?phone=" + number, function (data, status) {
                    $("#codeNumber").val(data);
                });
            }

        });


        function timego(ct) {
            var mt = 60;
            var timer = setInterval(function () {
                mt--;
                ct.attr("disabled", "disabled");
                ct.val(mt);
                if (mt == 0) {
                    clearInterval(timer);
                    ct.removeAttr("disabled");
                    ct.val("发送短信");
                }
            }, 1000);
        }
    });
</script>