<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    string hid = ViewData["hid"].ToString();
    string key = HotelCloud.Common.HCRequest.GetString("key");
    string hotelWeixinid = string.Empty;
    string userWeixinid = string.Empty;
    if (!string.IsNullOrEmpty(key) && key.Contains("@"))
    {
        List<string> list = key.Split('@').ToList();
        hotelWeixinid = list[0];
        userWeixinid = list[1];
    }
    string orderjson = HotelCloud.Common.HCRequest.GetString("orderjson");
    Hashtable orderjsondic = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(orderjson);
    WeiXin.Models.Home.Room room = Newtonsoft.Json.JsonConvert.DeserializeObject<WeiXin.Models.Home.Room>(orderjsondic["room"].ToString());
    WeiXin.Models.Home.RatePlan rateplan = Newtonsoft.Json.JsonConvert.DeserializeObject<WeiXin.Models.Home.RatePlan>(orderjsondic["rateplan"].ToString());
    int ishourroom = WeiXinPublic.ConvertHelper.ToInt(rateplan.IsHourRoom);
    string hours=rateplan.HourRoomType;
    string breakfast = "--";
    string area = "--";
    string nettype = "--";
    string floor = "--";
    string bedtype = "--";
    string addbed = "--";

   
    if (rateplan != null)
    {
        if (ishourroom == 0 && !string.IsNullOrEmpty(rateplan.ZaoCan))
        {
            breakfast = rateplan.ZaoCan;
        }
        if (!(string.IsNullOrEmpty(room.Area) || room.Area.Equals("0")))
        {
            area = room.Area;
            area = area.Replace("平方米", "").Replace("平方", "");
            area += "㎡";
        }
        if (!string.IsNullOrEmpty(room.NetType))
        {
            nettype = room.NetType;
        }
        if (!(string.IsNullOrEmpty(room.Floor) || room.Floor.Equals("0")))
        {
            floor = room.Floor;
        }
        if (!string.IsNullOrEmpty(room.BedType))
        {
            bedtype = room.BedType;
        }
        if (!string.IsNullOrEmpty(room.AddBed))
        {
            addbed = room.AddBed;
        }      
        
    
    }
    int paytype = WeiXinPublic.ConvertHelper.ToInt(rateplan.PayType);

    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    <meta name="keywords" content="关键词1,关键词2,关键词3" />
    <meta name="description" content="对网站的描述" />
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes" />
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*" />
    <title>填写订单</title>
    <link href=<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css?v=1.4 rel="stylesheet"
        type="text/css" />
    <link href=<%=ViewData["cssUrl"] %>/css/newpay.css?v=1.3 rel="stylesheet" type="text/css" />
    <link href=<%=ViewData["cssUrl"] %>/css/booklist/number-bar.css?v=1.1 rel="stylesheet"
        type="text/css" />
    <link href=<%=ViewData["cssUrl"] %>/css/msgbox_ui.css?v=1.0 rel="stylesheet" type="text/css" />
    <style type="text/css">
        .copy
        {
            display: none;
        }
        .discountstr
        {
            display: none;
        }
    </style>
</head>
<body>
    <section class="main">
    <div class="yu-pd10 yu-bbor">
        <div class="show  yu-arr type1">
            <h1 class="roomname">
            <%=ishourroom == 0 ? string.Format("{0}-{1}", room.RoomName, rateplan.RatePlanName) : string.Format("{0}-{1}小时钟点房", room.RoomName, rateplan.HourRoomType)%>
            </h1>
            <div class="yu-grey">
                <span class="yu-rmar30">入住：<label id="indate"><%=WeiXinPublic.ConvertHelper.ToDateTime(orderjsondic["indate"]).ToString("M月d日")%></label></span> <span>离店：<label id="outdate"><%=ishourroom == 1 ? WeiXinPublic.ConvertHelper.ToDateTime(orderjsondic["indate"]).ToString("M月d日") : WeiXinPublic.ConvertHelper.ToDateTime(orderjsondic["outdate"]).ToString("M月d日")%></label></span>
                <span>共<label class="days"><%=ishourroom == 1 ?  hours : orderjsondic["days"]%></label><%=ishourroom == 1 ? "小时" : "晚"%></span>
                <label style= "display:none"  id="total_days"><%=orderjsondic["days"] %></label>
            </div>
        </div>
    </div>
    <div class="hide yu-bbor">
        <div class="yu-pd10">
            <table class="details-tb">
                <tr>
                    <td>
                        早餐：<label class="breakfast"><%=breakfast%></label>
                    </td>
                    <td>
                        面积：<label class="area"><%=area %></label>
                    </td>
                </tr>
                <tr>
                    <td>
                        宽带：<label class="nettype"><%=nettype %></label>
                    </td>
                    <td>
                        楼层：<label class="floor"><%=floor %></label>
                    </td>
                </tr>
                <tr>
                    <td>
                        床型：<label class="bedtype"><%=bedtype %></label>
                    </td>
                    <td>
                        加床：<label class="addbed"><%=addbed%></label>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="yu-pd10" id="marklist">
        <ul>
            <%--<li class="yu-tb jishi">
                <p class="orderico type1 yu-tbc yu-nowrap">
                    <span></span>立即确认</p>
                <p class="yu-grey yu-h40 yu-tbc yu-lpad10 yu-font12">
                    <span>预订此房型后可立即确认订单。</span></p>
            </li>--%>
        <%if (paytype == 0)
          {
          %><li class="yu-tb prepay">
                <p class="orderico type3 yu-tbc yu-nowrap">
                    <span></span>在线付款</p>
                <p class="yu-grey yu-h40 yu-tbc yu-lpad10 yu-font12">
                    <span>在线完成支付，确认后到酒店直接入住。</span></p>
            </li>
            <li class="yu-tb prepay">
                <p class="orderico type4 yu-tbc yu-nowrap">
                    <span></span>保留房间</p>
                <p class="yu-grey yu-h40 yu-tbc yu-lpad10 yu-font12">
                    <span>订单确认后房间将为您整晚保留。</span></p>
            </li>


                   <li class="yu-tb prepay">
                <p class="orderico type6 yu-tbc yu-nowrap">
                    <span></span>取消规则</p>
                <p class="yu-grey yu-h40 yu-tbc yu-lpad10 yu-font12">
                    <span>预订后不可以取消或变更。</span></p>
            </li>

 
            
            <%
                     } %>
            <%if (paytype == 1)
              {
              %><li class="yu-tb facepay">
                <p class="orderico type5 yu-tbc yu-nowrap">
                    <span></span>到店付款</p>
                <p class="yu-grey yu-h40 yu-tbc yu-lpad10 yu-font12">
                    <span>需在到店后再前台付款办理入住。</span></p>
            </li><%
                     } %>
        </ul>
    </div>
    </section>
    <section class="main">
    <dl class="yu-grid yu-h60 yu-tbor yu-lpad10 yu-line60 yu-arr type2" style="<%=paytype == 0 && ishourroom == 0?"display:none":"" %>">
        <dt class="yu-greys yu-rmar30"><%=ishourroom == 1 ? "使用时段" : "保留到"%> </dt>
        <dd class="yu-overflow lasttimeselect" id="lasttime">
        </dd>
    </dl>
    <dl class="yu-grid yu-h60 yu-tbor yu-lpad10 yu-line60">
        <dt class="yu-greys yu-rmar30">房间数</dt>
        <dd class="yu-overflow">
            <div class="num-input">
                <span class="jian" addvalue="-1"></span>
                <input type="text" value="1" readonly="readonly" id="roomnum" />
                <span class="jia cur" addvalue="1"></span>
              
            </div>
        </dd>
    </dl>
    </section>
    <section class="main">
    <dl class="yu-grid yu-tbor yu-lpad10 yu-line60">
        <dt class="yu-greys yu-rmar30">入住人</dt>
        <dd class="yu-overflow room-input" id="usernamelist">
            <input type="text" placeholder="入住人姓名" class="input-type1 sp"/>
        </dd>
    </dl>
    <dl class="yu-grid yu-h60 yu-tbor yu-lpad10 yu-line60">
        <dt class="yu-greys yu-rmar30">手机号</dt>
        <dd class="yu-overflow">
        <input type="text" readonly="readonly" placeholder="联系人手机号" class="phonenumber input-type1 sp" />
        </dd>
    </dl>
    <dl style="display:none;" class="yu-grid yu-h60 yu-tbor yu-lpad10 yu-line60 yu-arr type2 yhq-select">
        <dt class="yu-greys yu-rmar30">红包</dt>
        <dd class="yu-overflow yu-tb yu-h60">
            <div class="yu-tbcell tip_youhongbao">
                <p class="orange yhq-type">
                    ￥<label id="couponprice">0</label></p>
                <p class="text-mark">
                    已从房费金额中扣减</p>
            </div>
            <p class="tip_wuhongbao" style="display:none">暂无可用</p>
        </dd>
    </dl>
    <dl class="yu-grid yu-h60 yu-tbor yu-lpad10 yu-line60">
        <dt class="yu-greys yu-rmar30">总房价</dt>
        <dd class="yu-overflow yu-tb yu-h60">
            <div class="yu-tbcell">
                <p class="orange">
                    ￥<label id="totalprice">0</label></p>
                <p class="text-mark">
                    <span class="discountstr">已优惠<label>0</label>元，</span><span class="memberpointsstr" style="display:none">可获<span class="yu-blue memberpoints">0</span>积分</span></p>
            </div>
        </dd>
    </dl>
    </section>
    <section class="main">
    <dl style="display:none;" class="yu-grid yu-h60 yu-tbor yu-lpad10 yu-line60">
        <dt class="yu-greys yu-rmar30">押金</dt>
        <dd class="yu-overflow">
            <div class="radio" id="foregiftselect">
            </div>
        </dd>
    </dl>
    <dl style="display:none;" class="yu-grid yu-h60 yu-tbor yu-lpad10 yu-line60">
        <dt class="yu-greys yu-rmar30">酒店押金</dt>
        <dd class="yu-overflow yu-tb yu-h60">
            <div class="yu-tbcell">
                <p class="orange">
                    ￥<label id="foregift">0</label></p>
                <p class="text-mark">
                    提前交酒店押金，离店后原路返还</p>
            </div>
        </dd>
    </dl>
     </section>
    <section class="main">
    <dl class="yu-grid yu-h60 yu-tbor yu-lpad10 yu-line60">
        <dt class="yu-greys yu-rmar30">发票</dt>
        <dd class="yu-overflow">
            <div class="radio" id="needinvoice">
            </div>
        </dd>
    </dl>
    <dl style="display:none;" class="yu-grid yu-h60 yu-tbor yu-lpad10 yu-line60">
        <dt class="yu-greys yu-rmar30">发票抬头</dt>
        <dd class="yu-overflow">
            <input type="text" placeholder="请输入个人/单位名称" class="input-type1 sp" id="invoicetitle" /></dd>
    </dl>
        <dl style="display:none;" class="yu-grid yu-h60 yu-tbor yu-lpad10 yu-line60">
        <dt class="yu-greys yu-rmar30">税号</dt>
        <dd class="yu-overflow">
            <input type="text" placeholder="请输入纳税人识别号" class="input-type1 sp" id="invoicenum" /></dd>
    </dl>
    </section>
    <section class="main">
    <dl class="yu-grid yu-h60 yu-tbor yu-lpad10 yu-line60 yu-arr type2">
        <dt class="yu-greys yu-rmar30">特殊要求</dt>
        <dd class="yu-overflow tsyq-type" id="demo">
        无
        </dd>
    </dl>
    </section>
    <section class="fix-bottom yu-h60 yu-grid yu-tbor">
    <div class="yu-overflow details-btn2 cur">
        <div class="yu-grid yu-lpad10 yu-alignc yu-h60">
            <div class="yu-overflow">
                <p class="oranges yu-font16">
                    <span class="paystr"><%=paytype == 0 ? "在线支付" : "到店支付"%></span>￥<label class="actualprice"></label></p>
                <p class="text-mark">
                    <span class="discountstr">为您优惠<label>0</label>元</span></p>
            </div>
            <a class="yu-grey   yu-rmar10 yu-arr type3 yu-rpad15 details-btn">明细 </a>
        </div>
    </div>
    <input type="button" value="<%=paytype == 0 ? "去支付" : "提交" %>" id="save" />
    <div class="pay-detail">
        <div class="yu-pad20">
            <ul class="pay-dateil-list">
                <li class="yu-grid">
                    <p>
                        <label class="paystr">
                        <%=paytype == 0 ? "在线支付" : "到店支付"%>
                        </label>
                    </p>
                    <p class="yu-overflow">
                        &nbsp;</p>
                    <p class="orange">
                        ￥<label class="actualprice">0</label></p>
                </li>
                <li class="yu-grid">
                    <p class="yu-greys">
                        房费(<label class="roomnum">1</label>间 X <label class="days"><%=ishourroom == 1 ?  hours : orderjsondic["days"]%></label><%=ishourroom == 1 ? "小时" : "晚"%>)</p>
                    <p class="yu-overflow yu-nowrap yu-greys">
                        ----------------------------------------------------------------------------------------</p>
                    <p class="yu-greys">
                        ￥<label class="alloriginalprice">0</label></p>
                </li>
                <li class="yu-grid" style="display:none;">
                    <p class="yu-greys">
                        <label id="lb_gradename"></label>折扣价</p>
                    <p class="yu-overflow yu-nowrap yu-greys">
                        ----------------------------------------------------------------------------------------</p>
                    <p class="orange">
                        <label class="discountprice">
                            </label></p>
                </li>
                <li class="yu-grid" style="display:none;">
                    <p class="yu-greys">
                        使用红包抵扣</p>
                    <p class="yu-overflow yu-nowrap yu-greys">
                        ----------------------------------------------------------------------------------------</p>
                    <p class="yu-greys">
                        -￥<label class="couponprice">0</label></p>
                </li>
                <li class="yu-grid" style="display:none;">
                    <p class="yu-greys">
                        提前交酒店押金</p>
                    <p class="yu-overflow yu-nowrap yu-greys">
                        ----------------------------------------------------------------------------------------</p>
                    <p class="yu-greys">
                        ￥<label class="foregift">0</label></p>
                </li>
            </ul>
        </div>
    </div>
    </section>
    <!-- 最晚到店 -->
    <section class="mask lasttime">
    <div class="mask-inner" id="lasttimebox">
        <div class="row yu-line60 yu-h60 yu-font20">
        <%=ishourroom == 1 ? "使用时段" : "最晚到店时间"%>
            </div>
            <%if (ishourroom == 0)
              {
              %><div class="row yu-line50 yu-font14 orange yu-bggrey">
            该酒店14：00办理入住，早到可能需要等待。</div><%
                                            } %>
        <div class="time-box select-box">
            <div class="row sp yu-grid yu-line60 yu-font60 copy">
                <p class="t-ico">
                    <span></span>
                </p>
                <p class="yu-overflow yu-bbor yu-font20 yu-lpad10 yu-textl">
                    <label>
                    </label>
                </p>
            </div>
        </div>
    </div>
    </section>
    <!-- 红包 -->
    <section class="mask yhq">
    <div class="mask-inner" id="couponlist">
        <div class="row yu-line60 yu-h60 yu-font20 yu-grid">
            <p class="yu-grey yu-w70 cancel">
                取消</p>
            <p class="yu-overflow">
                选择红包</p>
            <p class="yu-blue yu-w70 yhq-over">
                完成</p>
        </div>
        <div class="yhq-box select-box">
            <div class="row copy">
                <div class="hongbao type1 yu-grid">
                    <div class="yu-overflow yu-textl">
                      <p class="yu-bmar10"><i class="yu-font14">￥</i><i class="yu-font30 couponmoney">0</i></p>
                      <p class="yu-font14">订房红包</p>
                      <p class="yu-font14">有效期<span class="couponstdate"></span>-<span class="couponendate"></span></p>
                       <p class="yu-font14 yu-red2 nocan_hongbao" style="display:none">不可用原因：<label class="couponqiyong"></label>元起用</p>
                        <p class="yu-font14 yu-red2 nocan_hongbao2" style="display:none">不可用原因：订单金额小于红包金额</p>
                    </div>
                    <p class="hongbao-state"><span class="type1">未选用</span><span  class="type2">已选用</span></p>
                </div>
              </div>
        </div>
    </div>
    </section>
    <!-- 特殊要求 -->
    <section class="mask tsyq">
    <div class="mask-inner" id="demolist">
        <div class="row yu-line60 yu-h60 yu-font20 yu-grid">
            <p class="yu-grey yu-w70 cancel">
                取消</p>
            <p class="yu-overflow">
                特殊要求</p>
            <p class="yu-blue yu-w70 tsyq-over">
                完成</p>
        </div>
        <div class="row yu-line50 yu-font14 orange yu-bggrey">
            酒店针对您的偏好尽量安排，但不能保证，请您谅解。</div>
        <div class="tsyq-box select-box">
            <div class="row sp yu-grid yu-line60 yu-font60 copy">
                <p class="t-ico">
                    <span></span>
                </p>
                <p class="yu-overflow yu-bbor yu-font20 yu-lpad10 yu-textl">
                    <label>
                    </label>
                </p>
            </div>
        </div>
    </div>
    </section>
    <!-- 数字输入 -->
    <section class="number-bar">
      <div class="scrn">
        <p class="sjh">手机号</p>
        <p class="scrn-txt"></p>
      </div>
      <div class="num-key">       
      <div class="num-key-row">
          <p data="1" class="num-k">1</p>
          <p data="2" class="num-k">2</p>
          <p data="3" class="num-k">3</p>
        </div>        
      <div class="num-key-row">
          <p data="4" class="num-k">4</p>
          <p data="5" class="num-k">5</p>
          <p data="6" class="num-k">6</p>
        </div> 
      <div class="num-key-row">
          <p data="7" class="num-k">7</p>
          <p data="8" class="num-k">8</p>
          <p data="9" class="num-k">9</p>
        </div>
        <div class="num-key-row">
          <p class="submit">确认</p>
          <p data="0" class="num-k">0</p>
          <p class="del"><span></span></p>
        </div>                           
      </div>
      <div class="slide-bar"></div>
    </section>
</body>
</html>
<script type="text/javascript">
    var sys_hotelWeixinid = '<%=hotelWeixinid %>';
    var sys_userWeixinid = '<%=userWeixinid %>';
    var sys_orderjson = '<%=orderjson %>';
    var sys_hid = '<%=hid %>';
    var sys_key = '<%=key %>';
</script>
<script src=<%=ViewData["jsUrl"]%>/Scripts/jquery-1.8.0.min.js type="text/javascript"></script>
<script src=<%=ViewData["jsUrl"]%>/Scripts/m.hotel.com.core.min.js type="text/javascript"></script>
<script src=<%=ViewData["jsUrl"]%>/Scripts/viewjs/fillorder.js?v=2.0 type="text/javascript"></script>
<script type="text/javascript">
</script>
<%
    string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
    string openid = userWeixinid;
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
        logo =null,
        debug = false,
        userweixinid = openid,
        weixinid = hotelWeixinid,
        hotelid = int.Parse(hid),
        sharelink = sharelink
    };
    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("WeiXinShareConfig", WeiXinShareConfig);
    Html.RenderPartial("WeiXinShare", viewDic); 
%>