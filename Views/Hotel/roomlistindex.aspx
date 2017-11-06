<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<% 
    //Dictionary<string, object> ViewData = Model;

    string ratejson = ViewData["ratejson"].ToString();
    double graderate = WeiXinPublic.ConvertHelper.ToDouble(ViewData["graderate"]);
    double reduce = WeiXinPublic.ConvertHelper.ToDouble(ViewData["reduce"]);
    int couponType = WeiXinPublic.ConvertHelper.ToInt(ViewData["coupontype"]);
    string gradeName = WeiXinPublic.ConvertHelper.ToString(ViewData["gradeName"]);

    Hashtable ratejsonobj = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(ratejson);
    List<WeiXin.Models.Home.Room> roomlist = Newtonsoft.Json.JsonConvert.DeserializeObject<List<WeiXin.Models.Home.Room>>(ratejsonobj["roomlist"].ToString());
    Dictionary<string, Hashtable> hourroomRates = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, Hashtable>>(ratejsonobj["hourroomRates"].ToString());
    Dictionary<string, Hashtable> roomRates = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, Hashtable>>(ratejsonobj["roomRates"].ToString());
    int hourroomprice = hourroomRates.Count == 0 ? 0 : WeiXinPublic.ConvertHelper.ToInt(hourroomRates.First().Value["CtripPrice"]);
    Dictionary<string, List<Hashtable>> roomImgs = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, List<Hashtable>>>(ratejsonobj["roomImgs"].ToString());
    Hashtable StatisticsCountJson = Newtonsoft.Json.JsonConvert.DeserializeObject<Hashtable>(ratejsonobj["StatisticsCount"].ToString());
    int _takecoupon = WeiXinPublic.ConvertHelper.ToInt(StatisticsCountJson["CouPon"]);


    var customlist = ViewData["customlist"] as List<hotel3g.Models.Home.MemberCardCustom>;
    var memberinfo = ViewData["memberinfo"] as hotel3g.Repository.MemberInfo;

    string membershow = WeiXinPublic.ConvertHelper.ToString(ViewData["membershow"]);
    string dingfangmember = WeiXinPublic.ConvertHelper.ToString(ViewData["dingfangmember"]);
    int ismember = WeiXinPublic.ConvertHelper.ToInt(ViewData["ismember"]);

    //if (graderate > 0)
    //{
    //    hourroomprice = Convert.ToInt32(hourroomprice * graderate / 10);
    //}
%>
<%--钟点房--%>
<ul class="rooms-list sp2" id="hourroomlist" style="<%=hourroomRates.Count>0?"display: block": ""%>;">
    <li>
        <div class="room-content-head yu-grid yu-alignc">
            <div class="yu-overflow">
                <div class="room-name text-ell yu-line30">
                    <i class="iconfont icon-zhongdianfang1 yu-blue yu-f28r yu-rmar10r"></i>钟点房</div>
            </div>
            <div class="price-wrap yu-orange">
                <span class="yu-f28r">￥</span>&nbsp;<span class="yu-f48r yu-arial yu-fontb lowestprice"><%=hourroomprice%></span>&nbsp;<span
                    class="yu-f20r">&nbsp;起</span>
            </div>
        </div>
        <ul class="room-content sp">
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
                   string membershowstyle = string.Empty;
                   bool is_show_hyname = false;

                   string orderbtncss = string.Empty;
                   bool showdingfangnomember = false;

                   string hourRatePlanName = string.Empty;

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
                               hourRatePlanName = rateplan.RatePlanName;


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

                   }                   
            %><li class=" <%=i==-1?"copy":"" %>" <%=i>-1?"rateplanid='"+rateplanid+"' roomid='"+roomid+"' ishourroom='1' isvip='"+isvip+"' available='"+availableattr+"'":"" %>>
                <div class="yu-c60 yu-f30r yu-h67r yu-l67r yu-lpad36r yu-bor bbor">
                    <%=hourRatePlanName %>
                </div>
                <% if (membershow == "1" && isvip == 0)
                   {
                       is_show_hyname = true; %>
                <div class="yu-lrpad20r">
                    <div class="yu-grid yu-bor bbor yu-textc yu-f22r yu-h100r yu-alignc">
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
                            <p class="yu-c77">
                                <%=item.CardName%></p>
                            <p class="yu-c60">
                                ￥<%=currhyprice%></p>
                        </div>
                        <%}
                           }
                           else
                           {    %>
                        <div class="yu-overflow">
                            <p class="yu-c77">
                                普通会员</p>
                            <p class="yu-c60">
                                ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip0rate / 10) : price%></p>
                        </div>
                        <div class="yu-overflow">
                            <p class="yu-c77">
                                高级会员</p>
                            <p class="yu-c60">
                                ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip1rate / 10) : price%></p>
                        </div>
                        <div class="yu-overflow">
                            <p class="yu-c77">
                                白银会员</p>
                            <p class="yu-c60">
                                ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip2rate / 10) : price%></p>
                        </div>
                        <div class="yu-overflow">
                            <p class="yu-c77">
                                黄金会员</p>
                            <p class="yu-c60">
                                ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip3rate / 10) : price%></p>
                        </div>
                        <div class="yu-overflow">
                            <p class="yu-c77">
                                钻石会员</p>
                            <p class="yu-c60">
                                ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip4rate / 10) : price%></p>
                        </div>
                        <%}  %>
                    </div>
                </div>
                <%} %>
                <div class="yu-tbpad20r">
                    <div class="yu-lrpad36r yu-grid yu-alignc">
                        <div class="yu-overflow">
                            <p class="yu-c66 yu-f26r yu-bmar20r">
                            </p>
                            <div>
                                <div class="room-mark">
                                    <label class="roomhour">
                                        <%=hour%></label>小时钟点房
                                </div>
                                <div class="yu-bmar20r">
                                </div>
                                <%if (isvip == 1)
                                  { %>
                                <div class="room-mark">
                                    会员专享</div>
                                <%}
                                  else
                                  {
                                %>
                                <div class="room-mark">
                                    <%=string.IsNullOrEmpty(gradeName) ? "微信粉丝" : gradeName%></div>
                                <%
                                    } %>
                            </div>
                        </div>
                        <div class="yu-textr yu-rmar20r">
                            <div class="<%=i==-1?"":available==1?"yu-c60":"yu-c99" %>">
                                <span class="yu-f28r">￥</span><span class="yu-f48r yu-arial  price"><%=saleprice%></span>
                            </div>
                            <div>
                                <p class="yu-c77 yu-f20r originalprice" style="<%=discount>0?"display: block;": "" %>">
                                    ￥<label><%=originalprice %></label></p>
                                <p class="yu-c77 yu-f20r discount" style="<%=discount>0?"display: block;": "" %>">
                                    会员优惠￥<label><%=discount %></label></p>
                            </div>
                        </div>
                        <%
                            int roomstock = WeiXinPublic.ConvertHelper.ToInt(hourroomRates[roomtypeid]["RoomStock"]);

                            bool showorderbtn = false;

                            if (available == 0)
                            {
                                orderbtncss = "over";
                            }        
                        %>
                        <div class="yu-textc">
                            <div class="book-btn3 yu-bmar10r <%=available==0 ?  "over" : "" %>">
                                <p class="">
                                    <%=available ==0 ? "订完" : "订"%></p>
                                <%if (!showdingfangnomember && (isvip == 0 || (isvip == 1 && ismember == 1)))
                                  {
                                %>
                                <p class="btn_orderprice <%=paytype==1? "yu-c77":"yu-c60" %>">
                                    <%=paytype == 0 ? "在线付" : "到店付"%></p>
                                <%}
                                  else
                                  { %>
                                <p class="yu-c60 btn_hyprice">
                                    会员价</p>
                                <%} %>
                            </div>
                            <p class="yu-c60" style="<%=roomstock>=10  ||  available==0  ? "display:none": "" %>">
                                仅剩<%=roomstock%>间</p>
                        </div>
                    </div>
                </div>
                <%--
                                <div class="yu-overflow yu-greys">
                    <div class="room-name">
                        <%=roomname%>
                        (<label class="roomhour"><%=hour%></label>小时钟点房)
                    </div>
                    <div>
                    </div>
                    <%if (isvip == 1 && available == 1 && ismember == 1)
                      {
                    %><div class="hyzx-ico">
                        <p>
                            会员专享</p>
                    </div>
                    <%
                        } %>
                </div>
                <div class="room-price-wrap" style="<%=membershowstyle%>">
                    <p class="<%=discount>0?"":"yu-line50" %> yu-orange">
                        <i class="yu-font12">￥</i> <i class="yu-font20 price">
                            <%=saleprice%></i>
                    </p>
                    <p class="yu-font12 yu-grey originalprice" style="<%=discount>0?"display: block": "" %>;">
                        ￥<label><%=originalprice%></label></p>
                    <p class="yu-font12 yu-grey discount" style="<%=discount>0?"display: block": "" %>;">
                        会员优惠￥<label><%=discount%></label></p>
                </div>
                <% 
                    int roomstock = WeiXinPublic.ConvertHelper.ToInt(hourroomRates[roomtypeid]["RoomStock"]);
                    bool showorderbtn = false;
                    if (available == 0)
                    {
                        orderbtncss = "over";
                    } 
            
                %>
                <div class="order-btn <%=orderbtncss %>" style="<%=membershowstyle%>">
                    <%if (!showdingfangnomember && available == 1 && (isvip == 0 || (isvip == 1 && ismember == 1)))
                      {
                          showorderbtn = true;%>
                    <span class="<%=paytype==1?"type1":"" %>">
                        <%=paytype == 0 ? "在线付" : "到店付"%></span>
                    <%} %>
                    <p class="store" style="<%=roomstock>=10  ||  available==0  ? "display:none": "" %>">
                        仅剩<%=roomstock%>间</p>
                </div>
            </li>
            <% if (membershow == "1" && isvip == 0)
               { %>
            <li class="li_showprice">
                <div class="yu-grid yu-bor bbor yu-textc yu-font12 yu-bpad10">
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

                               if (price > reduce)
                               {
                                   currhyprice = Convert.ToInt32(price - item.Reduce);

                               }
                           }  %>
                    <div class="yu-overflow">
                        <p class="yu-c77">
                            <%=item.CardName%></p>
                        <p class="yu-c60">
                            ￥<%=currhyprice%></p>
                    </div>
                    <%}
                       }
                       else
                       {    %>
                    <div class="yu-overflow">
                        <p class="yu-c77">
                            普通会员</p>
                        <p class="yu-c60">
                            ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip0rate / 10) : price%></p>
                    </div>
                    <div class="yu-overflow">
                        <p class="yu-c77">
                            高级会员</p>
                        <p class="yu-c60">
                            ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip1rate / 10) : price%></p>
                    </div>
                    <div class="yu-overflow">
                        <p class="yu-c77">
                            白银会员</p>
                        <p class="yu-c60">
                            ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip2rate / 10) : price%></p>
                    </div>
                    <div class="yu-overflow">
                        <p class="yu-c77">
                            黄金会员</p>
                        <p class="yu-c60">
                            ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip3rate / 10) : price%></p>
                    </div>
                    <div class="yu-overflow">
                        <p class="yu-c77">
                            钻石会员</p>
                        <p class="yu-c60">
                            ￥<%=  memberinfo.vip0rate > 0 ?  Convert.ToInt32(price * memberinfo.vip4rate / 10) : price%></p>
                    </div>
                    <%} %>
                </div>
                <div class="yu-grid yu-line60 yu-h60">
                    <p class="yu-overflow yu-c66">
                        <%=string.IsNullOrEmpty(gradeName) ? "微信粉丝" :  gradeName%></p>
                    <p class="yu-c60 yu-rmar10">
                        <span class="yu-font12">￥</span><span class="yu-font20"><%=saleprice%></span></p>
                    <div class="order-btn yu-tmar10  <%=orderbtncss %>">
                        <% if (showorderbtn)
                           { %>
                        <span class="<%=paytype==1?"type1":"" %>">
                            <%=paytype == 0 ? "在线付" : "到店付"%></span>
                        <%} %>
                        <p class="store" style="<%=roomstock>=10  ||  available==0  ? "display:none": "" %>">
                            仅剩<%=roomstock%>间</p>
                    </div>
                </div>
            </li>
            <%} %>--%>
                <%
                    } %>
        </ul>
    </li>
</ul>
<%--房型列表--%>
<ul class="rooms-list sp2 yu-tbor1" id="roomlist" style="<%=roomRates.Count>0?"display: block": ""%>;">
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

                    // roominfoAry.Add(room.Window);
                    roominfoAry.Add(room.NetType);
                    roominfo = string.Join(" ", roominfoAry);
                }
                List<Hashtable> imglist = new List<Hashtable>();
                if (roomImgs.ContainsKey(roomid))
                {
                    imglist = roomImgs[roomid];
                    imgtotalcount = imglist.Count;
                    if (imgtotalcount > 0)
                    {
                        imgurl = imglist.First()["SmallUrl"].ToString();
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
                //int _price = WeiXinPublic.ConvertHelper.ToInt(roomratelist.First().Value["Price"]);
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
    %><li class="<%=i==-1?"copy":"" %>" <%=i>-1?"roomid='"+roomid+"'":"" %>>
        <div class="room-content-head yu-grid  yu-alignc <%=i==0?"cur": ""%>">
            <div class="room-pic">
                <img src="<%=imgurl %>" alt="" class="roomimg" />
                <span class="room-pic-num yu-font12"><span>
                    <%=imgtotalcount%></span>张</span>
            </div>
            <div class="yu-overflow">
                <div class="room-name text-ell">
                    <%=roomname%>
                </div>
                <div class="text-ell">
                    <span class="yu-f22r yu-c77 roominfo">
                        <%=roominfo%></span></div>
            </div>
            <div class="price-wrap <%=i==-1?"":firstavailable==1?"yu-orange":"yu-c99" %>">
                <span class="yu-f28r" style="<%=lowestprice.Equals("0") && i>-1?"display:none": ""%>;">
                    ￥</span> <span class="yu-f48r yu-arial yu-fontb lowestprice">
                        <%=lowestprice%></span> <span class="yu-f20r" style="<%=lowestprice.Equals("0") && i>-1?"display:none": ""%>;">
                            起</span>
            </div>
        </div>
        <ul class="room-content sp" style="<%=i==0?"display:block;": ""%>">
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
                    WeiXin.Models.Home.RatePlan rateplan = null;
                    string membershowstyle = string.Empty;

                    if (!roomid.Equals("-1"))
                    {
                        rateplanid = roomtypeid.Substring(roomtypeid.IndexOf("_") + 1);
                        rateplan = room.RateplanList.FirstOrDefault(r => r.ID.ToString().Equals(rateplanid));
                        if (rateplan != null)
                        {
                            rateplanname = rateplan.RatePlanName;
                            //rateplanname = string.Format("{0}({1})", rateplan.RatePlanName, rateplan.ZaoCan);
                            //if (rateplan.CheckOutTime.Contains("00") && !rateplan.CheckOutTime.Equals("12:00"))
                            //{
                            //    rateplanname += "(延迟到" + rateplan.CheckOutTime + "退房)";
                            //}
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

                    //如果订房需注册会员并不是会员的
                    if (dingfangmember == "1" && ismember == 0)
                    {
                        orderbtncss = "only-hy";
                        showdingfangnomember = true;
                    }

                    if (membershow == "1" && rateplan.IsVip == 0)
                    {
                        membershowstyle = "display:none";
                    }

                    bool is_show_hyname = false;
            %>
            <li class="rateplanitem" <%=i>-1?"roomid='"+roomid+"' rateplanid='"+rateplanid+"' ishourroom='0' available='"+availableattr+"' isvip='"+rateplan.IsVip+"'":"" %>>
                <div class="yu-c60 yu-f30r yu-h67r yu-l67r yu-lpad36r yu-bor bbor">
                    <%=rateplanname%></div>
                <% if (membershow == "1" && rateplan.IsVip == 0)
                   {
                       is_show_hyname = true; %>
                <div class="yu-lrpad20r">
                    <div class="yu-grid yu-bor bbor yu-textc yu-f22r yu-h100r yu-alignc">
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
                            <p class="yu-c77">
                                <%=item.CardName%></p>
                            <p class="yu-c60">
                                ￥<%=currhyprice%></p>
                        </div>
                        <%}
                           }
                           else
                           {    %>
                        <div class="yu-overflow">
                            <p class="yu-c77">
                                普通会员</p>
                            <p class="yu-c60">
                                ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip0rate / 10) : price%></p>
                        </div>
                        <div class="yu-overflow">
                            <p class="yu-c77">
                                高级会员</p>
                            <p class="yu-c60">
                                ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip1rate / 10) : price%></p>
                        </div>
                        <div class="yu-overflow">
                            <p class="yu-c77">
                                白银会员</p>
                            <p class="yu-c60">
                                ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip2rate / 10) : price%></p>
                        </div>
                        <div class="yu-overflow">
                            <p class="yu-c77">
                                黄金会员</p>
                            <p class="yu-c60">
                                ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip3rate / 10) : price%></p>
                        </div>
                        <div class="yu-overflow">
                            <p class="yu-c77">
                                钻石会员</p>
                            <p class="yu-c60">
                                ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip4rate / 10) : price%></p>
                        </div>
                        <%}  %>
                    </div>
                </div>
                <%} %>
                <div class="yu-tbpad20r">
                    <div class="yu-lrpad36r yu-grid yu-alignc">
                        <div class="yu-overflow">
                            <p class="yu-c66 yu-f26r yu-bmar20r">
                                <%=rateplan.ZaoCan%></p>
                            <div>
                                <div class="room-mark">
                                    <%=string.IsNullOrEmpty(rateplan.CheckOutTime) ? "12:00" : rateplan.CheckOutTime %>退房</div>
                                <div class="yu-bmar20r">
                                </div>
                                <%if (rateplan.IsVip == 1)
                                  { %>
                                <div class="room-mark">
                                    会员专享</div>
                                <%}
                                  else
                                  {
                                %>
                                <div class="room-mark">
                                    <%=string.IsNullOrEmpty(gradeName) ? "微信粉丝" : gradeName%></div>
                                <%
                                    } %>
                            </div>
                        </div>
                        <div class="yu-textr yu-rmar20r">
                            <div class="<%=i==-1?"":available==1?"yu-c60":"yu-c99" %>">
                                <span class="yu-f28r">￥</span><span class="yu-f48r yu-arial   price"><%=saleprice%></span>
                            </div>
                            <div>
                                <p class="yu-c77 yu-f20r originalprice" style="<%=discount>0?"display: block;": "" %>">
                                    ￥<label><%=originalprice %></label></p>
                                <p class="yu-c77 yu-f20r discount" style="<%=discount>0?"display: block;": "" %>">
                                    会员优惠￥<label><%=discount %></label></p>
                            </div>
                        </div>
                        <%
                     
                            int roomstock = WeiXinPublic.ConvertHelper.ToInt(roomRates[roomtypeid]["RoomStock"]);
                            bool showorderbtn = false;

                            if (available == 0)
                            {
                                orderbtncss = "over";
                            }        
                        %>
                        <div class="yu-textc">
                            <div class="book-btn3 yu-bmar10r <%=available==0 ?  "over" : "" %>">
                                <p class="">
                                    <%=available ==0 ? "订完" : "订"%></p>
                                <%if (!showdingfangnomember && (rateplan.IsVip == 0 || (rateplan.IsVip == 1 && ismember == 1)))
                                  {
                                %>
                                <p class="btn_orderprice <%=paytype==1? "yu-c77":"yu-c60" %>">
                                    <%=paytype == 0 ? "在线付" : "到店付"%></p>
                                <%}
                                  else
                                  { %>
                                <p class="yu-c60 btn_hyprice">
                                    会员价</p>
                                <%} %>
                            </div>
                            <p class="yu-c60" style="<%=roomstock>=10  ||  available==0  ? "display:none": "" %>">
                                仅剩<%=roomstock%>间</p>
                        </div>
                    </div>
                </div>
            </li>
            <%--  <li class="yu-grid rateplanitem" <%=i>-1?"roomid='"+roomid+"' rateplanid='"+rateplanid+"' ishourroom='0' available='"+availableattr+"' isvip='"+rateplan.IsVip+"'":"" %>>
                <div class="yu-overflow">
                    <div class="room-name text-ell yu-greys rateplanname">
                        <%=rateplanname%>
                    </div>
                    <%if (rateplan.IsVip == 1 && available == 1 && ismember == 1)
                      {
                    %><div class="hyzx-ico">
                        <p>
                            会员专享</p>
                    </div>
                    <%
                        } %>
                </div>
                <div class="room-price-wrap" style="<%=membershowstyle%>">
                    <p class="<%=discount == 0?"yu-line60":"" %> <%=i==-1?"":available==1?"yu-orange":"yu-grey" %>">
                        <i class="yu-font12">￥</i> <i class="yu-font20 price">
                            <%=saleprice%></i>
                    </p>
                    <p class="yu-font12 yu-grey originalprice" style="<%=discount>0?"display: block;": "" %>">
                        ￥<label><%=originalprice %></label></p>
                    <p class="yu-font12 yu-grey discount" style="<%=discount>0?"display: block;": "" %>">
                        会员优惠￥<label><%=discount %></label></p>
                </div>
                <%
                    
                    int roomstock = WeiXinPublic.ConvertHelper.ToInt(roomRates[roomtypeid]["RoomStock"]);
                    bool showorderbtn = false;
                    if (available == 0)
                    {
                        orderbtncss = "over";
                    }        
                
                %>
                <div class="order-btn <%=orderbtncss %>" style="<%=membershowstyle%>">
                    <%if (!showdingfangnomember && available == 1 && (rateplan.IsVip == 0 || (rateplan.IsVip == 1 && ismember == 1)))
                      {
                          showorderbtn = true;
                    %>
                    <span class="<%=paytype==1?"type1":"" %>">
                        <%=paytype == 0 ? "在线付" : "到店付"%></span>
                    <% } %>
                    <p class="store" style="<%=roomstock>=10  ||  available==0  ? "display:none": "" %>">
                        仅剩<%=roomstock%>间</p>
                </div>
            </li>
            <% if (membershow == "1" && rateplan.IsVip == 0)
               { %>
            <li class="li_showprice">
                <div class="yu-grid yu-bor bbor yu-textc yu-font12 yu-bpad10">
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

                               if (price > reduce)
                               {
                                   currhyprice = Convert.ToInt32(price - item.Reduce);

                               }
                           }  %>
                    <div class="yu-overflow">
                        <p class="yu-c77">
                            <%=item.CardName%></p>
                        <p class="yu-c60">
                            ￥<%=currhyprice%></p>
                    </div>
                    <%}
                       }
                       else
                       {    %>
                    <div class="yu-overflow">
                        <p class="yu-c77">
                            普通会员</p>
                        <p class="yu-c60">
                            ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip0rate / 10) : price%></p>
                    </div>
                    <div class="yu-overflow">
                        <p class="yu-c77">
                            高级会员</p>
                        <p class="yu-c60">
                            ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip1rate / 10) : price%></p>
                    </div>
                    <div class="yu-overflow">
                        <p class="yu-c77">
                            白银会员</p>
                        <p class="yu-c60">
                            ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip2rate / 10) : price%></p>
                    </div>
                    <div class="yu-overflow">
                        <p class="yu-c77">
                            黄金会员</p>
                        <p class="yu-c60">
                            ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip3rate / 10) : price%></p>
                    </div>
                    <div class="yu-overflow">
                        <p class="yu-c77">
                            钻石会员</p>
                        <p class="yu-c60">
                            ￥<%=  memberinfo.vip0rate > 0 ? Convert.ToInt32(price * memberinfo.vip4rate / 10) : price%></p>
                    </div>
                    <%} %>
                </div>
                <div class="yu-grid yu-line60 yu-h60">
                    <p class="yu-overflow yu-c66">
                        <%=string.IsNullOrEmpty(gradeName) ? "微信粉丝" :  gradeName%></p>
                    <p class="<%=available == 1 ? "yu-c60" : "yu-grey"%>  yu-rmar10">
                        <span class="yu-font12">￥</span><span class="yu-font20"><%=saleprice%></span></p>
                    <div class="order-btn yu-tmar10  <%=orderbtncss %>">
                        <% if (showorderbtn)
                           { %>
                        <span class="<%=paytype==1?"type1":"" %>">
                            <%=paytype == 0 ? "在线付" : "到店付"%></span>
                        <%} %>
                        <p class="store" style="<%=roomstock>=10  ||  available==0  ? "display:none": "" %>">
                            仅剩<%=roomstock%>间</p>
                    </div>
                </div>
            </li>
            <%} %>--%>
            <% } %>
        </ul>
    </li>
    <%} %>
</ul>
<script type="text/javascript">
    var sync_ratejson = '<%=ratejson %>';
  
</script>
