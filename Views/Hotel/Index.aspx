<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    string hid = ViewData["hid"].ToString();
    string hotelWeixinid = string.Empty;
    string key = HotelCloud.Common.HCRequest.GetString("key");
    if (ViewData["hotelWeixinid"] != null)
    {
        hotelWeixinid = ViewData["hotelWeixinid"].ToString();
    }
    string userWeixinid = string.Empty;
    if (ViewData["userWeixinid"] != null)
    {
        userWeixinid = ViewData["userWeixinid"].ToString();
    }
    string generatesign = ViewData["generatesign"].ToString();
    string ratejson = ViewData["ratejson"].ToString();
    string MemberCardRuleJson = ViewData["MemberCardRuleJson"].ToString();
     Hashtable memberCardRule = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(MemberCardRuleJson);
     int ismember = Convert.ToBoolean( memberCardRule["becomeMember"]) ? 0 : 1;
    
   
    
    string firstimgurl = ViewData["firstimgurl"] == null ? null : ViewData["firstimgurl"].ToString();
    hotel3g.Models.Hotel hotel = ViewData["hotel"] as hotel3g.Models.Hotel;
    ViewData["hotelname"] = hotel.SubName;
    
    
    string hoteljson = Newtonsoft.Json.JsonConvert.SerializeObject(hotel);

    DateTime indate = Convert.ToDateTime(ViewData["indate"]);
    DateTime outdate = Convert.ToDateTime(ViewData["outdate"]);

    string indatestr = indate.ToString("M-d");
    string outdatestr = outdate.ToString("M-d"); 

    Hashtable ratejsonobj = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(ratejson);
    List<WeiXin.Models.Home.Room> roomlist = Newtonsoft.Json.JsonConvert.DeserializeObject<List<WeiXin.Models.Home.Room>>(ratejsonobj["roomlist"].ToString());
    Dictionary<string, Hashtable> hourroomRates = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, Hashtable>>(ratejsonobj["hourroomRates"].ToString());
    Dictionary<string, Hashtable> roomRates = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, Hashtable>>(ratejsonobj["roomRates"].ToString());
    int hourroomprice = hourroomRates.Count == 0 ? 0 : WeiXinPublic.ConvertHelper.ToInt(hourroomRates.First().Value["CtripPrice"]);

    double graderate = WeiXinPublic.ConvertHelper.ToDouble(ViewData["graderate"]);
    double reduce = WeiXinPublic.ConvertHelper.ToDouble(ViewData["reduce"]);
    int couponType = WeiXinPublic.ConvertHelper.ToInt(ViewData["couponType"]);
    string gradeName = WeiXinPublic.ConvertHelper.ToString(ViewData["gradeName"]);

    var customlist = ViewData["customlist"] as List<hotel3g.Models.Home.MemberCardCustom>;
    var memberinfo = ViewData["memberinfo"] as hotel3g.Repository.MemberInfo;

     string membershow = WeiXinPublic.ConvertHelper.ToString(ViewData["membershow"]);
     string dingfangmember= WeiXinPublic.ConvertHelper.ToString(ViewData["dingfangmember"]);
    
    
     int  memberbasics=  WeiXinPublic.ConvertHelper.ToInt(ViewData["memberbasics"]);
    
 
    Dictionary<string, List<Hashtable>> roomImgs = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, List<Hashtable>>>(ratejsonobj["roomImgs"].ToString());
    Hashtable StatisticsCountJson = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(ratejsonobj["StatisticsCount"].ToString());
    int _takecoupon = WeiXinPublic.ConvertHelper.ToInt(StatisticsCountJson["CouPon"]);

    //if (graderate > 0)
    //{
    //    hourroomprice = Convert.ToInt32(hourroomprice * graderate / 10);
    //}
    
    
    

    ViewDataDictionary roomlistDic = new ViewDataDictionary();
    roomlistDic.Add("ratejson", ratejson);
    roomlistDic.Add("graderate", graderate);
    roomlistDic.Add("reduce", reduce);
    roomlistDic.Add("coupontype", couponType);
    roomlistDic.Add("customlist", customlist);
    roomlistDic.Add("memberinfo", memberinfo);
    roomlistDic.Add("gradename", gradeName);
    roomlistDic.Add("membershow", membershow);
    roomlistDic.Add("dingfangmember", dingfangmember);
    roomlistDic.Add("ismember", ismember);
    
    
   var baseHotelCommentInfo= ViewData["baseHotelCommentInfo"] as hotel3g.Models.BaseHotelCommentInfo;
   if (baseHotelCommentInfo == null)
   {
       baseHotelCommentInfo = new hotel3g.Models.BaseHotelCommentInfo();
   }

   //旅行社版本
   int istravel = WeiXin.Common.NormalCommon.IsLXSDoMain() ? 1 : 0;
    
    //分享用户
   string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
   int isshare =  userWeixinid.Contains(wkn_shareopenid) ? 1 : 0;
    
    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", hotelWeixinid);
    viewDic.Add("hId", hid);
    viewDic.Add("uwx", userWeixinid);

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
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <title><%=  ViewData["hotelname"]%></title>
    <link href=<%=ViewData["cssUrl"] %>/swiper/swiper-3.4.1.min.css?v=1.1 rel="stylesheet"
        type="text/css" />
    <link href=<%=ViewData["cssUrl"] %>/css/booklist/jquery-ui.css?v=1.2 rel="stylesheet"
        type="text/css" />
     <link href=<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css?v=1.8 rel="stylesheet"
        type="text/css" /> 
 
<%--  <link href="../../css/booklist/font/iconfont.css?v=1.0" rel="stylesheet"
        type="text/css" />--%>

  <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/iconfont-base64.css"/>

    <link href=<%=ViewData["cssUrl"] %>/css/booklist/list.css?v=1.3 rel="stylesheet"
        type="text/css" />
    <link href=<%=ViewData["cssUrl"] %>/css/booklist/newlist.css?v=1.2 rel="stylesheet"
        type="text/css" />
    <link href=<%=ViewData["cssUrl"] %>/css/newpay.css?v=1.1 rel="stylesheet" type="text/css" />
    <link href=<%=ViewData["cssUrl"] %>/css/msgbox_ui.css?v=1.1 rel="stylesheet" type="text/css" />
       <script src=<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js type="text/javascript"></script>


              <script src=<%=ViewData["jsUrl"] %>/Scripts/fontSize.js type="text/javascript"></script>
             <link href=<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css rel="stylesheet"
        type="text/css" />      
        
    <style type="text/css">
        .originalprice, .discount
        {
            display: none;
        }
        
        .copy
        {
            display: none;
        }
        
        #hourroomlist, #roomlist, #groupsale, #groupsalelist
        {
            display: none;
        }
        
        #groupsalelist .yu-overflow .babel.type1, #groupsalelist .yu-overflow .babel.type2, #groupsalelist .yu-overflow .babel.type3
        {
            display: none;
        }
        
        .yu-line30
        {
            line-height: 30px;
        }
        
        .ui-datepicker td span, .ui-datepicker td a {
           line-height: 1.08rem !important;
         }
              
      .ui-datepicker td span, .ui-datepicker td a
        {
            line-height:50px;
      }
  
   #datepicker .specialdays a
     {
       line-height:0.8rem !important;
     }
     .specialdays.first:after, .specialdays.last:after
     {
      top:0.55rem;
    }
  
     .room-num
        {
            display: none;
        } 
        
        .room-price-d
        {
            display: none;
        }
        
        
	  body,.foot-nav{max-width: 750px;}
 
 
 
	
  </style>
 
 
</head>
<body>
    <form method="post" action="/hotel/fillorder/<%=hid %>?key=<%=key %>" id="orderform"
    style="display: none">
    <input type="hidden" name="orderjson" />
    <input type="submit" id="submitorder" />
    </form>
    <div class="base-page">
        <div id="main">
            <div class="hotel-img-box swiper-container swiper-container-horizontal">
             <div class="sc-bg iconfont icon-shoucang" id="user_sc" style="<%=istravel==0 ? "display:none" : "" %>")></div>
                <p class="hotel-name" id="hotelname" style="display:none">
                    <%=hotel.SubName %>
                </p>
                <p class="hotel-img-num">
                    <span class="activeIndex"></span>/<label class="totalindex">0</label></p>
                <div class="swiper-wrapper">
                    <%if (!string.IsNullOrEmpty(firstimgurl))
                      {
                    %><div class="swiper-slide" style="width: 375px;">
                        <img src="<%=firstimgurl %>" alt="" /></div>
                    <%
                        } %>
                </div>
                <div class="mask-bg img-info yu-grid" id="takecoupon"  data-num="<%=_takecoupon %>"     style="display:none">
                    <p class="yu-overflow yu-font14">
                        您有酒店红包未领取！【用红包立减】</p>
                    <p class="yu-tpad5">
                        <a href="javascript:window.location.href='/Home/CouPon/<%=hid %>?key=<%=hotelWeixinid %>@<%=userWeixinid %>'" class="get-quan yu-font14">马上领取</a></p>
                </div>
            </div>
            <ul class="hotel-info yu-bmar20r">
                <li class="yu-arr" id="tomap" href="/Hotel/Map/<%=hid %>?key=<%=key %>"><a href="javascript:;"
                    class="yu-grid">
                    <div class="hotel-add text-ell yu-c11 yu-overflow" id="address">
                        <%=hotel.Address %>
                    </div>
                    <p class="yu-blue yu-font14">
                        地图</p>
                </a></li>
                <li class="yu-arr" id="calltel" href=""><a href="javascript:;" class="yu-grid">
                      <p class="iconfont icon-jiudiandianhua yu-c11 yu-f26r"></p>
                    <div class="hotel-add text-ell  yu-c11 yu-overflow">
                        电话：<label id="hoteltel"><%=hotel.Tel %></label>
                    </div>
                    <p class="yu-blue yu-font14">
                        拨打</p>
                </a></li>
                <li class="yu-arr" id="hotelserveli" href="/Hotel/HotelService/<%=hid %>?key=<%=key %>"  >
                    <a href="javascript:;" class="yu-grid">
                        <div class="hotel-add text-ell yu-c11 yu-overflow" id="hotelserve">

     <% if (hotel.KeFang!=null && hotel.KeFang.Contains("宽带"))
   { %>
        <i class="iconfont icon-kuandaishangwang yu-rmar20r"></i> <!--宽带上网-->
        <%} %>
          <% if (hotel.FuWu != null && hotel.FuWu.Contains("wifi"))
             { %>
        <i class="iconfont icon-gonggongquyuwifi yu-rmar20r"></i> <!--公共wifi-->
        <%} %>

          <% if (hotel.KeFang != null && hotel.KeFang.Contains("热水"))
             { %>
        <i class="iconfont icon-quantianreshui yu-rmar20r"></i> <!--全天热水-->
        <%} %>

          <% if (hotel.KeFang != null && hotel.KeFang.Contains("吹风机"))
             { %>
        <i class="iconfont icon-chuifengji yu-rmar20r"></i> <!--吹风机-->

        <%} %>

          <% if (hotel.KeFang != null && hotel.KeFang.Contains("空调"))
             { %>
        <i class="iconfont icon-kongtiao yu-rmar20r"></i> <!--空调-->

        <%} %>     

           <% if (hotel.CanYin != null && hotel.CanYin.Contains("餐厅"))
       { %>
        <i class="iconfont icon-jiudiancanting yu-rmar20r"></i> <!--酒店餐厅-->
        <%} %>
 
        <% if (hotel.FuWu != null && hotel.FuWu.Contains("停车场"))
       { %>
        <i class="iconfont icon-tingchechang yu-rmar20r"></i> <!--停车场-->
        <%} %>
 
               
                        </div>
                        <p class="yu-blue yu-font14">
                            详情</p>
                    </a></li>

                    <% if (ViewData["commentopen"] != null && ViewData["commentopen"].ToString() == "1"  && baseHotelCommentInfo.CommentAllCount >0 )
                       { %>
                        <li class="yu-arr">
  		<a href="/Hotel/CommentList/<%=hid %>?key=<%=key %>" class="yu-grid">
  			<p class="yu-overflow yu-c11"><%=baseHotelCommentInfo.CommentAllCount%>条评论/<%=baseHotelCommentInfo.AllAvg%>分</p>
  			<p class="yu-blue yu-font14">评论</p>   
  		</a>    	
    </li>
         <%} %>

            </ul>
            <div class="rooms-list-box">
                <ul class="rooms-date-change">
                    <li class="yu-grid yu-alignc"><span class="yu-font20 start-date yu-c11" id="indate" datestr="<%=indate.ToString("yyyy-MM-dd") %>"
                        datetype="indate">
                        <%=indatestr%></span> <span class="yu-font12  yu-c77" datetype="indate"><span id="indatestr">
                            今天</span>入住</span> <span class="border1"></span><span class="yu-font20 end-date  yu-c11"
                                id="outdate" datetype="outdate" datestr="<%=outdate.ToString("yyyy-MM-dd") %>">
                                <%=outdatestr %></span><span class="yu-font12 yu-c77 yu-overflow">&nbsp;<span id="outdatestr"
                                    datetype="outdate">明天</span>离店 </span>
                                    <%--<span class="yu-font12 fr yu-rmar20 yu-blue"
                                        datetype="indate">共1晚</span>--%>
                                        <span class="yu-font14   yu-rmar30 yu-blue">共<label id="days">1</label>晚</span>
                                         </li>
                </ul>
            </div>
            <div id="roomlistdiv">
                <%Html.RenderPartial("roomlistindex", roomlistDic); %></div>
            <%--团购特惠--%>
            <%Html.RenderPartial("ProductSale", viewDic); %>
        </div>
    </div>
    <div class="date-page">
        <div class="back" style="display:none">
        </div>
        <div class="top" style="display:none">
            选择日期
        </div>
        <div id="datepicker">
        </div>
    </div>
    <section class="mask hyk-mask">
    <div class="get-card">
        <div class="part1">
            <span class="close"></span>
        </div>
        <div class="part2">
            <h3 class="gift" style="display:none">
                领取会员红包，更多特权更多优惠!</h3>
            <h3 class="gift" style="display:none">
                <label class="hongbao">0</label>元红包【预订立减】</h3>
            <div class="mem-right">
                <h4>
                    会员权益</h4>
                <!-- <h5>会员卡优惠与积分说明</h5> -->
                <table>
                    <tr>
                        <td>
                            特权内容
                        </td>
                        <td>
                            订房优惠
                        </td>
                        <td>
                            积分加成
                        </td>
                    </tr>


                             <tr class="copy"  data-custom='<%=customlist.Count%>'>
                        <td>
                        <label class="membername"></label>
                        </td>
                        <td>
                            <label class="viprate"></label>折
                        </td>
                        <td>
                            <label class="vipplus"></label>倍
                        </td>
                    </tr>

                    <% foreach (var item in customlist)
                       {%>                          
                
                    <tr >
                        <td>
                        <label class="membername"><%=item.CardName %></label>
                        </td>
                        <td>
                            <label class="viprate"><%=item.CouponType==0 ?  Convert.ToDouble( item.Discount)+"折"  :"立减￥"+ Convert.ToDouble( item.Reduce)  %></label>
                        </td>
                        <td>
                            <label class="vipplus"> <%= Convert.ToDouble( item.JiFen )%></label>倍
                        </td>
                    </tr>
                       <%  } %>
                </table>
            </div>
        </div>
        <div class="part3">
            <a href="/MemberCard/MemberRegister/<%=hid %>?key=<%=key %>" class="get-btn"></a>
        </div>
    </div>
    </section>
    <!-- 领取红包 -->
    <div class="mask lqhb">
        <div class="mask-inner">
            <div class="row yu-line60 yu-h60 yu-font20 yu-grid yu-bmar10">
                <p class="yu-overflow">
                    酒店红包</p>
            </div>
            <div class="yhq-box select-box" id="SurplusCouponlist">
                <div class="row copy">
                    <div class="hongbao type2 yu-grid">
                        <div class="yu-overflow yu-textl">
                            <p class="yu-bmar10">
                                <i class="yu-font14">￥</i><i class="yu-font30 price">0</i></p>
                            <p class="yu-font14">
                                订房红包</p>
                            <p class="yu-font14">
                                有效期<span class="stime"></span>-<span class="etime"></span></p>
                        </div>
                        <p class="hongbao-state">
                            <span class="type1">立即领取</span><span class="type2">已领取</span></p>
                    </div>
                </div>
            </div>
            <div class="get-btn2">
                完成</div>
        </div>
    </div>
    <div class="mask big-pic">
        <div class="inner">
            <div class="close">
            </div>
            <h3>
                <label class="roomname">
                </label>
            </h3>
            <div class="big-img-box swiper-container2">
                <div class="swiper-wrapper">
                    <%--<div class="swiper-slide">
                        <img src="../images/114.png" /></div>--%>
                </div>
            </div>
            <div class="big-img-detail">
                <table>
                    <tr>
                        <td>
                            早餐：<label class="breakfast"></label>
                        </td>
                        <td>
                            面积：<label class="area"></label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            宽带：<label class="nettype"></label>
                        </td>
                        <td>
                            楼层：<label class="floor"></label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            床型：<label class="bedtype"></label>
                        </td>
                        <td>
                            加床：<label class="addbed"></label>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="yu-grid">
                <p class="yu-overflow yu-line50 yu-lpad10 yu-h50 yu-orange">
                    <i class="yu-font14">￥</i> <i class="yu-font24 price">0</i>
                </p>
                <p class="book-btn">
                    预订</p>
            </div>
        </div>
    </div>

    <span class="selectNum"   style="display:none"></span>
    <span class="select_qd"   style="display:none">确定</span>
 


     <%
        //微信分享
    
        string openid = userWeixinid;
        string newkey = string.Format("{0}@{1}", hotelWeixinid, openid);

        if (!openid.Contains(wkn_shareopenid))
        {
            //非二次分享 获取推广员信息
            var CurUser = hotel3g.Repository.MemberHelper.GetMemberCardByUserWeiXinNO(hotelWeixinid, openid);
            ///原链接已经是分享过的链接
            newkey = string.Format("{0}@{1}_{2}", hotelWeixinid, wkn_shareopenid, CurUser.memberid);
        }

        string desn = hotel.Address;
        string sharelink = string.Format("http://hotel.weikeniu.com{0}?key={1}", Request.Url.LocalPath, newkey);
        hotel3g.PromoterEntitys.WeiXinShareConfig WeiXinShareConfig = new hotel3g.PromoterEntitys.WeiXinShareConfig()
        {
            title = hotel.SubName + "(分享)",
            desn = desn,
            logo = hotel.HotelLog,
            debug = false,
            userweixinid = openid,
            weixinid = hotelWeixinid,
            hotelid = int.Parse(hid),
            sharelink = sharelink
        };
         viewDic.Add("WeiXinShareConfig",WeiXinShareConfig);

    %>
    <%Html.RenderPartial("Footer", viewDic); %>
</body>
</html>
<script type="text/javascript">
    var sys_hid = '<%=hid %>';
    var sys_userWeixinid = '<%=userWeixinid %>';
    var sys_hotelWeixinid = '<%=hotelWeixinid %>';
    var sys_tokenkey = '';
    var sys_token = '';
    var sys_generatesign = '<%=generatesign %>';
    var sys_ratejson = '<%=ratejson %>';
    var sys_MemberCardRuleJson = '<%=MemberCardRuleJson %>';
    var sys_hoteljson = '<%=hoteljson %>';
    var sys_graderate = '<%=graderate %>';
    var sys_reduce = '<%=reduce %>';
    var sys_coupontype = '<%=couponType %>';
    var sys_key = '<%=key %>';
    var membershow = '<%=membershow %>';
    var sys_gradename = '<%=gradeName %>';

    var sys_dingfangmember = '<%=dingfangmember %>';
    var sys_ismember = '<%=ismember %>';
    var sys_istravel = '<%=istravel %>';
    var sys_isshare = '<%=isshare %>';

    var sy_memberbasics = '<%=memberbasics %>';
    
</script>
<script src="../../Scripts/layer/layer.js" type="text/javascript"></script>
<script src=<%=ViewData["jsUrl"] %>/swiper/swiper-3.4.1.jquery.min.js type="text/javascript"></script>
<%--<script src=<%=ViewData["jsUrl"] %>/css/booklist/jQuery-ui.min.hotelindex.js type="text/javascript"></script> --%>
<script src="../../css/booklist/jquery-ui.js" type="text/javascript"></script>
<script src="../../css/booklist/date-range-picker.js?v=1.1" type="text/javascript"></script>
<script src=<%=ViewData["jsUrl"] %>/Scripts/viewjs/hotelindex.js?v=1.33 type="text/javascript"></script>
<script type="text/javascript">

    var dClickNum = 0;

    $("#datepicker").datepicker({
        dateFormat: 'yy-mm-dd',
        dayNamesMin: ["日", "一", "二", "三", "四", "五", "六"],
        monthNames: ["1月", "2月", "3月", "4月", "5月", "6月",
         "7月", "8月", "9月", "10月", "11月", "12月"],
        yearSuffix: '年',
        showMonthAfterYear: true,
        minDate: new Date(),
        numberOfMonths: 2,
        maxDate: "+2m",
        showButtonPanel: false,
        onSelect: function (selectedDate, e) {

            if (dClickNum == 0) {
                //console.log("第一次")
                dClickNum = 1;
            } else {
                //console.log("第二次")
                dClickNum = 0;
            }
 
        }
    });

    $(".select_qd").click(function () {
       
        if ($("#datepicker .specialdays").length != 2) {
            //   layer.msg("请选择入住离店日期");
            return false;
        }


        $("#days").text($(".selectNum").text());

        var b_date = $($("#datepicker .specialdays")[0]).attr("title");
        var e_date = $($("#datepicker .specialdays")[1]).attr("title");

        var c_month = b_date.split('-')[1].indexOf("0") == 0 ? b_date.split('-')[1].replace("0", "") : b_date.split('-')[1];
        var c_day = b_date.split('-')[2].indexOf("0") == 0 ? b_date.split('-')[2].replace("0", "") : b_date.split('-')[2];

        $("#indate").text(c_month + "-" + c_day);
        $('#indate').attr('datestr', b_date);
        $('#indatestr').text(getdatestr(b_date));


        c_month = e_date.split('-')[1].indexOf("0") == 0 ? e_date.split('-')[1].replace("0", "") : e_date.split('-')[1];
        c_day = e_date.split('-')[2].indexOf("0") == 0 ? e_date.split('-')[2].replace("0", "") : e_date.split('-')[2];

        $("#outdate").text(c_month + "-" + c_day);
        $('#outdate').attr('datestr', e_date);
        $('#outdatestr').text(getdatestr(e_date));


        getratejson();
        $(".base-page").show();
        $(".date-page").hide();



    });

    function BindData() {

    }


    //收藏按钮
    var mytimer = null;
    function removeCur() {
        window.clearTimeout(mytimer);
        mytimer = window.setTimeout(
    		function () {
    		    $(".sc-bg").removeClass("cur");
    		}, 1000
    	)
  }

    $(".sc-bg").click(function () {          
     
        OpCollection(""); 

    })



    function OpCollection(op) {

        if (sys_istravel == 0) {
            return;
        }

        var shoucangStatus = $("#user_sc").hasClass("icon-yishoucang") ? 0 : 1;
        var linkurl = "/hotel/index/" + sys_hid + "?key=" + sys_hotelWeixinid + "@" + sys_userWeixinid;

        $.ajax({
            url: '/action/Collection',
            type: 'post',
            data: { hotelId: sys_hid, hotelweixinid: sys_hotelWeixinid, userweixinid: sys_userWeixinid, url: linkurl, status: shoucangStatus, type: "dingfang", key: sys_key, op: op, scName: '<%=ViewData["hotelname"] %>' },
            success: function (data) {

                if (data.Status == 0) {

                    if (op == "query") {
                        if (data.Mess == "ok") {
                            $("#user_sc").addClass("icon-yishoucang").removeClass("icon-shoucang");
                        }
                    }

                    else {

                        $("#user_sc").toggleClass("icon-shoucang").toggleClass("icon-yishoucang").addClass("cur");
                        removeCur();
                    }
                }
            }
        });
    }


 
</script>
