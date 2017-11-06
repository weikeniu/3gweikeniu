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
    string firstimgurl = ViewData["firstimgurl"] == null ? null : ViewData["firstimgurl"].ToString();
    hotel3g.Models.Hotel hotel = ViewData["hotel"] as hotel3g.Models.Hotel;
    ViewData["hotelname"] = hotel.SubName;
    string hoteljson = Newtonsoft.Json.JsonConvert.SerializeObject(hotel);
    string indatestr = DateTime.Now.ToString("M-d");
    string outdatestr = DateTime.Now.AddDays(1).ToString("M-d");

    Hashtable ratejsonobj = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(ratejson);
    List<WeiXin.Models.Home.Room> roomlist = Newtonsoft.Json.JsonConvert.DeserializeObject<List<WeiXin.Models.Home.Room>>(ratejsonobj["roomlist"].ToString());
    Dictionary<string, Hashtable> hourroomRates = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, Hashtable>>(ratejsonobj["hourroomRates"].ToString());
    Dictionary<string, Hashtable> roomRates = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, Hashtable>>(ratejsonobj["roomRates"].ToString());
    int hourroomprice = hourroomRates.Count == 0 ? 0 : WeiXinPublic.ConvertHelper.ToInt(hourroomRates.First().Value["CtripPrice"]);

    double graderate = WeiXinPublic.ConvertHelper.ToDouble(ViewData["graderate"]);
    double reduce = WeiXinPublic.ConvertHelper.ToDouble(ViewData["reduce"]);
    int couponType = WeiXinPublic.ConvertHelper.ToInt(ViewData["couponType"]);
    string gradeName = WeiXinPublic.ConvertHelper.ToString(ViewData["gradeName"]);

    Hashtable memberCardRule = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(MemberCardRuleJson);
    int ismember = Convert.ToBoolean(memberCardRule["becomeMember"]) ? 0 : 1;


    var customlist = ViewData["customlist"] as List<hotel3g.Models.Home.MemberCardCustom>;
    var memberinfo = ViewData["memberinfo"] as hotel3g.Repository.MemberInfo;
    string membershow = WeiXinPublic.ConvertHelper.ToString(ViewData["membershow"]);
    string dingfangmember = WeiXinPublic.ConvertHelper.ToString(ViewData["dingfangmember"]);

    Dictionary<string, List<Hashtable>> roomImgs = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, List<Hashtable>>>(ratejsonobj["roomImgs"].ToString());
    Hashtable StatisticsCountJson = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(ratejsonobj["StatisticsCount"].ToString());
    int _takecoupon = WeiXinPublic.ConvertHelper.ToInt(StatisticsCountJson["CouPon"]);

    //if (graderate > 0)
    //{
    //    hourroomprice = Convert.ToInt32(hourroomprice * graderate / 10);
    //}


    DateTime beginTime = Convert.ToDateTime(ViewData["beginTime"]);
    DateTime endTime = Convert.ToDateTime(ViewData["endTime"]);


    //分享用户
    string wkn_shareopenid = hotel3g.Models.DAL.PromoterDAL.WX_ShareLinkUserWeiXinId;
    int isshare = userWeixinid.Contains(wkn_shareopenid) ? 1 : 0;

    ViewDataDictionary roomlistDic = new ViewDataDictionary();
    roomlistDic.Add("ratejson", ratejson);
    roomlistDic.Add("graderate", graderate);

    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", hotelWeixinid);
    viewDic.Add("hId", hid);
    viewDic.Add("uwx", userWeixinid);

    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
    <title>
        <%=ViewData["hotelname"]%></title>
    <link type="text/css" rel="stylesheet" href="<%= ViewData["cssUrl"] %>/css/booklist/sale-date.css?v=1.2" />
    <link type="text/css" rel="stylesheet" href="<%= ViewData["cssUrl"] %>/css/booklist/new-style.css?v=1.1" />
    <script type="text/javascript" src="<%= ViewData["cssUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <link type="text/css" rel="stylesheet" href="<%= ViewData["cssUrl"] %>/css/booklist/fontSize.css?v=1.1" />
    <script type="text/javascript" src="<%= ViewData["cssUrl"] %>/Scripts/fontSize.js?v=1.0"></script>
</head>
<body>
    <article class="full-page">

    
			<form  method="post" action="/hotelA/fillorder/<%=hid %>?key=<%=key %>" id="orderform" >
             <input type="hidden" name="orderjson" />
    <input type="submit" id="submitorder" style="display:none"   /> 
    </form>

    <span   style="display:none"  class="yu-font20 start-date yu-greys" id="indate" datestr="<%= beginTime.ToString("yyyy-MM-dd") %>"
                        datetype="indate">
                        <%=indatestr%></span>
<span  style="display:none"  class="yu-font20 end-date yu-greys"
                                id="outdate" datetype="outdate" datestr="<%=endTime.ToString("yyyy-MM-dd") %>">
                                <%=outdatestr %></span>
 <label style="display:none"  id="days">1</label>

   <p  style="display:none"   class="hotel-name" id="hotelname">
                    <%=hotel.SubName %>
                </p>

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
            title = hotel.SubName+" (分享)",
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


     <%Html.RenderPartial("HeaderA", viewDic); %>
     
          	<section class="show-body">
			<section class="content2">
				<ul class="booking-list">

             <%--  钟点房--%>
                    <li style="<%=hourroomRates.Count>0?"display: block": "display:none"%>;">

                   <% for (int i = 0; i < hourroomRates.Count; i++)
                      {
                          string roomtypeid = null;
                          string roomid = null;
                          string rateplanid = null;
                          string roomname = null;
                          int hour = 0;
                          int price = 0;
                          int saleprice = 0;
                          int originalprice = 0;
                          int discount = 0;
                          int paytype = 0;
                          int available = 0;
                          int isvip = 0;
                          int availableattr = 0;

                          int imgtotalcount = 0;
                          string imgurl = null;
                          string membershowstyle = string.Empty;

                          string orderbtncss = string.Empty;
                          bool showdingfangnomember = false;
                          int roomstock = 1;


                          if (i > -1)
                          {
                              roomtypeid = hourroomRates.Keys.ToList()[i];
                              roomid = roomtypeid.Remove(roomtypeid.IndexOf("_"));
                              rateplanid = roomtypeid.Substring(roomtypeid.IndexOf("_") + 1);
                              WeiXin.Models.Home.Room room = roomlist.FirstOrDefault(r => r.ID.ToString().Equals(roomid));
                              if (room != null)
                              {
                                  roomname = room.RoomName;
                                  WeiXin.Models.Home.RatePlan rateplan = room.RateplanList.FirstOrDefault(r => r.ID.ToString().Equals(rateplanid));
                                  if (rateplan != null)
                                  {
                                      hour = WeiXinPublic.ConvertHelper.ToInt(rateplan.HourRoomType);
                                      paytype = WeiXinPublic.ConvertHelper.ToInt(rateplan.PayType);
                                      isvip = rateplan.IsVip;
                                  }
                              }
                              price = WeiXinPublic.ConvertHelper.ToInt(hourroomRates[roomtypeid]["Price"]);
                              saleprice = price;
                              if (couponType == 0 && graderate > 0 && isvip == 0)
                              {
                                  originalprice = price;
                                  saleprice = Convert.ToInt32(price * graderate / 10);
                                  discount = price - saleprice;
                              }
                              else if (couponType == 1 && reduce > 0 && isvip == 0)
                              {
                                  originalprice = price;
                                  if (price > reduce)
                                  {
                                      saleprice = Convert.ToInt32(price - reduce);
                                      discount = price - saleprice;
                                  }
                              }
                              available = WeiXinPublic.ConvertHelper.ToInt(hourroomRates[roomtypeid]["Available"]);
                              availableattr = available;

                              //此价格计划为会员专享，如预订人不是会员，则房态为满房
                              if (isvip == 1 && ismember == 0)
                              {
                                  availableattr = 0;
                                  orderbtncss = "only-hy";
                              }


                              if (dingfangmember == "1" && ismember == 0)
                              {
                                  orderbtncss = "only-hy";
                                  showdingfangnomember = true;
                              }


                              if (membershow == "1" && isvip == 0)
                              {
                                  membershowstyle = "display:none";
                              }

                              roomstock = WeiXinPublic.ConvertHelper.ToInt(hourroomRates[roomtypeid]["RoomStock"]);

                              List<Hashtable> imglist = new List<Hashtable>();
                              if (roomImgs.ContainsKey(roomid))
                              {
                                  imglist = roomImgs[roomid];
                                  imgtotalcount = imglist.Count;
                                  if (imgtotalcount > 0)
                                  {
                                      imgurl = imglist.First()["BigUrl"].ToString();
                                  }
                              }
                              else
                              {
                                  imgurl = "../../images/defaultRoomImg.jpg";
                              }
                          }

                      
            %>                   
	        

                <% if (i == 0)
                   { %>
						<div class="show-header">
							<div class="inner">
								<img src="<%=imgurl%>" />
								<div class="txt-bar yu-grid yu-alignc">
									<p class="yu-overflow">钟点房</p>
									<p>￥<%=hourroomprice%></p>
									<p class="btn-block">预订</p>
								</div>
							</div>
							<div class="silde-arr yu-bor bbor"></div>
						</div>
                        <%} %>

                
						<div class="slide-bottom   yu-bgw yu-bor bbor" <%=i>-1?"rateplanid='"+rateplanid+"' roomid='"+roomid+"' ishourroom='1' isvip='"+isvip+"' available='"+availableattr+"'":"" %>>
                        	 
							<a href="#"  class="yu-grid yu-alignc yu-bor bbor  yu-pad10r  m-h120r">
								<div class="yu-overflow yu-c66">	
                                 <p> <%=roomname%>	(<%=hour%>小时钟点房)</p>						 
								
                                    <%if (isvip == 1 && available == 1 && ismember == 1)
                                      {%>
									<div class="hyzx-ico"><p>会员专享</p></div>

                                    <%}%>
								</div>
							<div class="yu-textr yu-rmar10" style="<%=membershowstyle%>">
									<p class="yu-c40 yu-font18" ><i class="yu-font12">￥</i>   <%=saleprice%></p>
									<p class="yu-c99 yu-font12"  style="<%=discount>0 ? "display: block;": "display: none;" %>">￥<%=originalprice%></p>
									<p class="yu-c99 yu-font12 discount"  style="<%=discount>0 ? "display: block;": "display: none;" %>">会员优惠￥
                                    <label><%=discount%></label></p>
                                     <p class="yu-font12  yu-red2"style="<%=roomstock>=10  ||  available==0  ? "display:none" : "" %>">仅剩<%=roomstock%>间</p>
								</div>
                                    <%
                                        bool showorderbtn = false;
                                        if (available == 0)
                                        {
                                            //orderbtncss = "over";
                                        }
                                      
                               %>

								<div class="order-btn <%=orderbtncss %>" style="<%=membershowstyle%>">
                                   <%if (!showdingfangnomember && (isvip == 0 || (isvip == 1 && ismember == 1)))
                                     {
                                         showorderbtn = true;%>
                   
                                           <span><%=paytype == 0 ? "在线付" : "到店付"%></span><%
                                                                                             } %>					        
						        </div>
                          	</a>

                                   
                               <% if (membershow == "1" && isvip == 0)
                                  { %>                            
                             <div>
							        
							        <div class="yu-grid yu-bor bbor yu-textc yu-tbpad5r yu-bgf3">

                                     <% if (customlist.Count > 0)
                                        { %>
                     <% foreach (var item in customlist)
                        {
                            double currhyprice = price;

                            if (item.CouponType == 0 && item.Discount > 0)
                            {
                                currhyprice = Convert.ToInt32(price * item.Discount / 10);

                            }
                            else if (item.CouponType == 1 && item.Reduce > 0)
                            {

                                if (price > item.Reduce)
                                {
                                    currhyprice = Convert.ToInt32(price - item.Reduce);

                                }
                            }  %>
							        	<div class="yu-overflow">
							        		<p class="yu-f20r yu-c77"><%=item.CardName%></p>
							        		<p class="yu-c40 yu-f20r">￥<%=currhyprice%></p>
							        	</div>							         
                                       <%}
                                        }
                                        else
                                        {    %>
                                       <div class="yu-overflow">
                        <p class="yu-f20r yu-c77">
                            普通会员</p>
                        <p class="yu-c40 yu-f20r">
                            ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip0rate / 10) : price%></p>
                    </div>
                    <div class="yu-overflow">
                        <p class="yu-f20r yu-c77">
                            高级会员</p>
                        <p class="yu-c40 yu-f20r">
                            ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip1rate / 10) : price%></p>
                    </div>
                    <div class="yu-overflow">
                        <p class="yu-f20r yu-c77">
                            白银会员</p>
                        <p class="yu-c40 yu-f20r">
                            ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip2rate / 10) : price%></p>
                    </div>
                    <div class="yu-overflow">
                        <p class="yu-f20r yu-c77">
                            黄金会员</p>
                        <p class="yu-c40 yu-f20r">
                            ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip3rate / 10) : price%></p>
                    </div>
                    <div class="yu-overflow">
                        <p class="yu-f20r yu-c77">
                            钻石会员</p>
                        <p class="yu-c40 yu-f20r">
                            ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip4rate / 10) : price%></p>
                    </div>	

                                      <%} %>
							        </div>								 

                                   		<a href="#" class="yu-grid yu-alignc yu-tbpad10r yu-bgf3 yu-lrpad10r m-h120r">
										<div class="yu-overflow yu-c66">
											<p> <%=string.IsNullOrEmpty(gradeName) ? "微信粉丝" :  gradeName%></p>
										</div>
										<div class="yu-textr yu-rmar10">
											<p class="yu-c40 yu-font18"><i class="yu-font12">￥</i><%=saleprice%></p>
                                             <p class="yu-font12  yu-red2"style="<%=roomstock>=10  ||  available==0  ? "display:none" : "" %>">仅剩<%=roomstock%>间</p>
										</div>
									         <div class="order-btn  <%=orderbtncss %>">
                                  <% if (showorderbtn)
                                     { %>
                                  <span class="<%=paytype==1?"type1":"" %>">
                                       <%=paytype == 0 ? "在线付" : "到店付"%></span>
                                       <%} %>
                                   </div>
							       </a>


							      </div>    
                               <%} %>


 
						</div>			

                    <%} %>
                	</li>

<%--房型列表--%>

                 <%
                     List<string> roomidlist = roomRates.Select(item => item.Key.Remove(item.Key.IndexOf("_"))).Distinct().ToList();
                     roomRates.Add("-1", null);
                     for (int i = 0; i < roomidlist.Count; i++)
                     {
                         string lowestprice = "0";
                         int firstavailable = 0;
                         string roomid = null;
                         string rateplanid = null;
                         string roomname = null;
                         int imgtotalcount = 0;
                         string imgurl = null;
                         string roominfo = null;
                         WeiXin.Models.Home.Room room = null;
                         if (i > -1)
                         {
                             roomid = roomidlist[i];
                             room = roomlist.FirstOrDefault(r => r.ID.ToString().Equals(roomid));
                             if (room != null)
                             {
                                 roomname = room.RoomName;
                                 List<string> roominfoAry = new List<string>();
                                 if (!(string.IsNullOrEmpty(room.Area) || room.Area.Equals("0")))
                                 {
                                     string area = room.Area.Replace("平方米", "").Replace("平方", "");
                                     area += "㎡";
                                     roominfoAry.Add(area);
                                 }

                                 string cur_bedType = room.BedType;
                                 if (!string.IsNullOrEmpty(room.BedArea) && room.BedArea.Contains("*") && room.BedArea.Contains("cm"))
                                 {
                                     int ss = 0;
                                     if (int.TryParse(room.BedArea.Split('*')[0].Replace("cm", ""), out ss))
                                     {
                                         cur_bedType += ss / Convert.ToDouble(100) + "m";
                                     }
                                     else
                                     {
                                         cur_bedType += room.BedArea;
                                     }
                                 }
                                 else
                                 {
                                     cur_bedType += room.BedArea;
                                 }
                                 roominfoAry.Add(cur_bedType);

                                 //roominfoAry.Add(room.Window);
                                 //roominfoAry.Add(room.NetType);
                                 roominfo = string.Join(" ", roominfoAry);
                             }
                             List<Hashtable> imglist = new List<Hashtable>();
                             if (roomImgs.ContainsKey(roomid))
                             {
                                 imglist = roomImgs[roomid];
                                 imgtotalcount = imglist.Count;
                                 if (imgtotalcount > 0)
                                 {
                                     imgurl = imglist.First()["BigUrl"].ToString();
                                 }
                             }
                             else
                             {
                                 imgurl = "../../images/defaultRoomImg.jpg";
                             }
                         }
                         else
                         {
                             roomid = "-1";
                         }
                         Dictionary<string, Hashtable> roomratelist = roomRates.Where(r => r.Key.StartsWith(roomid)).ToDictionary(r => r.Key, r => r.Value);
                         if (i > -1)
                         {
                             int _price = WeiXinPublic.ConvertHelper.ToInt(roomratelist.First().Value["CtripPrice"]);
                             //if (graderate > 0)
                             //{
                             //    _price = Convert.ToInt32(_price * graderate / 10);
                             //}
                             lowestprice = _price.ToString();
                             firstavailable = WeiXinPublic.ConvertHelper.ToInt(roomratelist.First().Value["Available"]);
                             if (lowestprice.Equals("0"))
                             {
                                 lowestprice = "已售完";
                             }
                         }
            
            
            %>

					<li >
						<div class="show-header">
							<div class="inner">
								<img src="<%=imgurl %>" />
								<div class="txt-bar yu-grid yu-alignc">
									<p class="yu-overflow">     <%=roomname%>    <%=roominfo%></p>
									<p>￥<%=lowestprice%></p>
									<p class="btn-block">预订</p>
								</div>
							</div>
							<div class="silde-arr yu-bor bbor"></div>
						</div>

                         <%
                             foreach (string roomtypeid in roomratelist.Keys)
                             {
                                 string rateplanname = null;
                                 int price = 0;
                                 int saleprice = 0;
                                 int originalprice = 0;
                                 int discount = 0;
                                 int available = 0;
                                 int paytype = 0;
                                 string membershowstyle = string.Empty;
                                 WeiXin.Models.Home.RatePlan rateplan = null;
                                 if (!roomid.Equals("-1"))
                                 {
                                     rateplanid = roomtypeid.Substring(roomtypeid.IndexOf("_") + 1);
                                     rateplan = room.RateplanList.FirstOrDefault(r => r.ID.ToString().Equals(rateplanid));
                                     if (rateplan != null)
                                     {
                                         rateplanname = string.Format("{0}({1})", rateplan.RatePlanName, rateplan.ZaoCan);
                                         if (rateplan.CheckOutTime.Contains("00") && !rateplan.CheckOutTime.Equals("12:00"))
                                         {
                                             rateplanname += "(延迟到" + rateplan.CheckOutTime + "退房)";
                                         }
                                         paytype = WeiXinPublic.ConvertHelper.ToInt(rateplan.PayType);
                                     }

                                     price = WeiXinPublic.ConvertHelper.ToInt(roomRates[roomtypeid]["Price"]);
                                     saleprice = price;
                                     if (couponType == 0 && graderate > 0 && rateplan.IsVip == 0)
                                     {
                                         originalprice = price;
                                         saleprice = Convert.ToInt32(price * graderate / 10);
                                         discount = price - saleprice;
                                     }

                                     else if (couponType == 1 && reduce > 0 && rateplan.IsVip == 0)
                                     {
                                         originalprice = price;
                                         if (price > reduce)
                                         {
                                             saleprice = Convert.ToInt32(price - reduce);
                                             discount = price - saleprice;
                                         }
                                     }
                                     available = WeiXinPublic.ConvertHelper.ToInt(roomRates[roomtypeid]["Available"]);
                                 }
                                 if (rateplan == null)
                                 {
                                     rateplan = new WeiXin.Models.Home.RatePlan();
                                 }

                                 int availableattr = available;

                                 string orderbtncss = string.Empty;
                                 bool showdingfangnomember = false;

                                 //此价格计划为会员专享，如预订人不是会员，则房态为满房

                                 if (rateplan.IsVip == 1 && ismember == 0)
                                 {
                                     availableattr = 0;
                                     orderbtncss = "only-hy";
                                 }


                                 if (dingfangmember == "1" && ismember == 0)
                                 {
                                     orderbtncss = "only-hy";
                                     showdingfangnomember = true;
                                 }

                                 if (membershow == "1" && rateplan.IsVip == 0)
                                 {
                                     membershowstyle = "display:none";
                                 }

                                 int roomstock = WeiXinPublic.ConvertHelper.ToInt(roomRates[roomtypeid]["RoomStock"]);
                                                  
            %>	 
						<div class="slide-bottom  yu-bgw yu-bor bbor"  <%=i>-1?"roomid='"+roomid+"' rateplanid='"+rateplanid+"' ishourroom='0' available='"+availableattr+"' isvip='"+rateplan.IsVip+"'":"" %>>	 
							<a href="#"  class="yu-grid yu-alignc yu-bor bbor yu-pad10r   m-h120r">
								<div class="yu-overflow yu-c66">
									<p>      <%=rateplanname%></p>
                                        <%if (rateplan.IsVip == 1 && available == 1 && ismember == 1)
                                          {  %>
								 	<div class="hyzx-ico"><p>会员专享</p></div>                                             
                                              
                                              <%}%>
								</div>
								<div class="yu-textr yu-rmar10" style="<%=membershowstyle%>">
									<p class="yu-c40 yu-font18"><i class="yu-font12">￥</i>   <%=saleprice%></p>
                                 <p class="yu-c99 yu-font12"  style="<%=discount>0 ? "display: block;": "display: none;" %>">￥<%=originalprice %></p>
									<p class="yu-c99 yu-font12 discount"  style="<%=discount>0 ? "display: block;": "display: none;" %>">会员优惠￥   <label><%=discount%></label></p>
                                    <p class="yu-font12  yu-red2"style="<%=roomstock>=10  ||  available==0  ? "display:none" : "" %>">仅剩<%=roomstock%>间</p>
								</div>
                               <%  
                                   bool showorderbtn = false;
                                   if (available == 0)
                                   {
                                       // orderbtncss = "over";
                                   }                                         
                                        %>

                          	<div class="order-btn <%=orderbtncss %>" style="<%=membershowstyle%>"  >
                                    <%if (!showdingfangnomember && (rateplan.IsVip == 0 || (rateplan.IsVip == 1 && ismember == 1)))
                                      {
                                          showorderbtn = true;
                                  %>
                               <span><%=paytype == 0 ? "在线付" : "到店付"%></span>
                    <%} %>
								 </div>	
							</a>    
                            
                               <% if (membershow == "1" && rateplan.IsVip == 0)
                                  { %>                            
                             <div>
							        
							        <div class="yu-grid yu-bor bbor yu-textc yu-tbpad5r yu-bgf3">

                                     <% if (customlist.Count > 0)
                                        { %>
                     <% foreach (var item in customlist)
                        {
                            double currhyprice = price;

                            if (item.CouponType == 0 && item.Discount > 0)
                            {
                                currhyprice = Convert.ToInt32(price * item.Discount / 10);

                            }
                            else if (item.CouponType == 1 && item.Reduce > 0)
                            {

                                if (price > item.Reduce)
                                {
                                    currhyprice = Convert.ToInt32(price - item.Reduce);

                                }
                            }  %>
							        	<div class="yu-overflow">
							        		<p class="yu-f20r yu-c77"><%=item.CardName%></p>
							        		<p class="yu-c40 yu-f20r">￥<%=currhyprice%></p>
							        	</div>							         
                                       <%}
                                        }
                                        else
                                        {    %>
                                       <div class="yu-overflow">
                        <p class="yu-f20r yu-c77">
                            普通会员</p>
                        <p class="yu-c40 yu-f20r">
                            ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip0rate / 10) : price%></p>
                    </div>
                    <div class="yu-overflow">
                        <p class="yu-f20r yu-c77">
                            高级会员</p>
                        <p class="yu-c40 yu-f20r">
                            ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip1rate / 10) : price%></p>
                    </div>
                    <div class="yu-overflow">
                        <p class="yu-f20r yu-c77">
                            白银会员</p>
                        <p class="yu-c40 yu-f20r">
                            ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip2rate / 10) : price%></p>
                    </div>
                    <div class="yu-overflow">
                        <p class="yu-f20r yu-c77">
                            黄金会员</p>
                        <p class="yu-c40 yu-f20r">
                            ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip3rate / 10) : price%></p>
                    </div>
                    <div class="yu-overflow">
                        <p class="yu-f20r yu-c77">
                            钻石会员</p>
                        <p class="yu-c40 yu-f20r">
                            ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip4rate / 10) : price%></p>
                    </div>	

                                      <%} %>
							        </div>								 

                                   		<a href="#" class="yu-grid yu-alignc yu-tbpad10r yu-bgf3 yu-lrpad10r m-h120r">
										<div class="yu-overflow yu-c66">
											<p> <%=string.IsNullOrEmpty(gradeName) ? "微信粉丝" :  gradeName%></p>
										</div>
										<div class="yu-textr yu-rmar10">
											<p class="yu-c40 yu-font18"><i class="yu-font12">￥</i><%=saleprice%></p>
                                             <p class="yu-font12  yu-red2"style="<%=roomstock>=10  ||  available==0  ? "display:none" : "" %>">仅剩<%=roomstock%>间</p>
										</div>
									         <div class="order-btn  <%=orderbtncss %>">
                                  <% if (showorderbtn)
                                     { %>
                                  <span class="<%=paytype==1?"type1":"" %>">
                                       <%=paytype == 0 ? "在线付" : "到店付"%></span>
                                       <%} %>
                                   </div>
							       </a>


							      </div>    
                               <%} %>
                            
                            
                                                
						</div>
                        <%} %>
					</li>


                    <%} %>
				 
				</ul>
			</section>
           
		</section>	
        </article>
    <script>
        $(function () {
            //下拉
            $(".booking-list>li").on("click", function () {
                $(this).toggleClass("cur");
                $(this).find(".slide-bottom").slideToggle(100);
            })
            $(".slide-bottom").on("click", function (e) {
                e.stopPropagation()
            })
        })




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
        var sys_dingfangmember = '<%=dingfangmember %>';
        var sys_isshare = '<%=isshare %>';

        var ratejson = $.parseJSON(sys_ratejson);
        var MemberCardRuleJson = $.parseJSON(sys_MemberCardRuleJson);
        var hoteljson = $.parseJSON(sys_hoteljson);
        var imgjson = ratejson['roomImgs'];
        var MemberCardRuleJson = $.parseJSON(sys_MemberCardRuleJson);

        var memberid = '';
        var ismember = 0;
        var username = '';
        var mobile = '';

        fetchMemberCardRuleJson(sys_MemberCardRuleJson);
        getShareRooms();


        $('.booking-list div[rateplanid]').bind('click', function () {
            var that = $(this);
            var available = that.attr('available');
            var isvip = that.attr('isvip');

            //            if (!that.find('.order-btn').hasClass('over') && available == 1) {
            //                var roomid = that.attr('roomid');
            //                var rateplanid = that.attr('rateplanid');
            //                var ishourroom = that.attr('ishourroom');
            //                var discount = parseInt(that.find('.discount label').text());
            //                submitorder(roomid, rateplanid, ishourroom, discount);
            //            } else if (ismember == 0 && isvip == 1) {
            //                window.location.href = '/MemberCard/MemberRegister/' + sys_hid + '?key=' + sys_key;
            //            }


            if (ismember == 0 && sys_dingfangmember == "1") {
                window.location.href = '/MemberCardA/MemberRegister/' + sys_hid + '?key=' + sys_key;
                return;
            }

            if (ismember == 0 && isvip == 1) {
                window.location.href = '/MemberCardA/MemberRegister/' + sys_hid + '?key=' + sys_key;
            }

            else {
                var roomid = that.attr('roomid');
                var rateplanid = that.attr('rateplanid');
                var ishourroom = that.attr('ishourroom');
                var discount = parseInt(that.find('.discount label').text());
                submitorder(roomid, rateplanid, ishourroom, discount);

            }

        });


        function submitorder(roomid, rateplanid, ishourroom, discount) {
            var roomkey = 'roomRates';
            if (ishourroom == 1) {
                roomkey = 'hourroomRates';
            }

            var roomtypeid = roomid + '_' + rateplanid;


            if (ratejson[roomkey][roomtypeid]['Available'] == 0 || ratejson[roomkey][roomtypeid]['Price'] == 0) {
                //return false;
            }

            var roominfo = getroominfo(roomtypeid, ratejson['roomlist']);
            var orderjson = {};


            orderjson['indate'] = $('#indate').attr('datestr');
            orderjson['outdate'] = $('#outdate').attr('datestr');
            orderjson['room'] = roominfo['room'];
            orderjson['rateplan'] = roominfo['rateplan'];
            orderjson['roomid'] = roomid;
            orderjson['rateplanid'] = rateplanid;
            var days = parseInt($('#days').text());
            orderjson['price'] = ratejson[roomkey][roomtypeid]['Price'] * days;
            orderjson['available'] = ratejson[roomkey][roomtypeid]['Available'];
            orderjson['ishourroom'] = ishourroom;
            orderjson['roomstock'] = ratejson[roomkey][roomtypeid]['RoomStock'];
            orderjson['days'] = days;
            orderjson['MemberCardRule'] = MemberCardRuleJson;
            orderjson['discount'] = discount;
            orderjson['hotelname'] = $('#hotelname').text().trim();
            //        orderjson['room']['RateplanList'] = undefined;
            orderjson['tokenkey'] = sys_tokenkey;
            orderjson['token'] = sys_token;
            orderjson['memberid'] = memberid;
            orderjson['username'] = username;
            orderjson['mobile'] = mobile;
            orderjson['roomimg'] = $(".booking-list div[rateplanid='" + rateplanid + "']").parent().find(".show-header img").attr("src");
            $('#orderform input[name="orderjson"]').val(JSON.stringify(orderjson));
            $('#submitorder').trigger('click');
        }



        function getroominfo(roomtypeid, roomlistJson) {
            var roomid = roomtypeid.substring(0, roomtypeid.indexOf('_'));
            var rateplanid = roomtypeid.substring(roomtypeid.indexOf('_') + 1, 20);
            var info = {};
            $.each(roomlistJson, function (k, room) {
                if (room['ID'] == roomid) {
                    info['room'] = room;
                    $.each(room['RateplanList'], function (k2, rateplan) {
                        if (rateplan['ID'] == rateplanid) {
                            info['rateplan'] = rateplan;
                            return false;
                        }
                    });
                    return false;
                }
            });
            return info;
        }



        function fetchMemberCardRuleJson(data) {
            var _json = $.parseJSON(data);
            MemberCardRuleJson = _json['rule'];
            memberid = _json['memberid'];
            ismember = _json['becomeMember'] ? 0 : 1;
            username = _json['username'];
            mobile = _json['mobile'];

            return;

            if (_json['becomeMember']) {
                var memberinfo = _json['memberinfo'];
                var table = $('.hyk-mask .mem-right table');
                if (memberinfo['gift'] > 0) {
                    $('.hyk-mask .gift').show();
                    $('.hyk-mask .hongbao').text(memberinfo['gift'] * memberinfo['giftnum']);
                }
                var membernameAry = ['普通会员', '高级会员', '白金会员', '黄金会员', '钻石会员'];
                for (var i = 0; i < 5; i++) {
                    var tr = $('.hyk-mask .mem-right table tr.copy').clone(true).removeClass('copy');
                    tr.find('.membername').text(membernameAry[i]);
                    var viprate = memberinfo['vip' + i + 'rate'];
                    if (viprate == 0) {
                        tr.find('.viprate').closest('td').text('--');
                        tr.find('.viprate').remove();
                    } else {
                        tr.find('.viprate').text(viprate.toFixed(1));
                    }
                    var vipplus = memberinfo['vip' + i + 'plus'];
                    if (vipplus == 0) {
                        tr.find('.vipplus').closest('td').text('--');
                        tr.find('.vipplus').remove();
                    } else {
                        tr.find('.vipplus').text(vipplus.toFixed(1));
                    }
                    table.append(tr);
                }
                $(".hyk-mask").fadeIn();
            }
        }

        function getShareRooms() {
            if (sys_isshare == 1) {

                $(".booking-list li .slide-bottom").each(function (i, item) {

                    if ($(this).find(".only-hy").length > 0  ) {     
                        if ($(this).siblings(".slide-bottom").length == 0) {
                            $(this).parents("li").hide();
                        }
                        $(this).remove();
                    }
                });

            }
        }


    </script>
</body>
</html>
