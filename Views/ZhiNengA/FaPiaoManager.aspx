<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    string weixinID = HotelCloud.Common.HCRequest.GetString("weixinID");
    string hotelid = RouteData.Values["id"].ToString();

    string userWeiXinID = "";
    userWeiXinID = hotel3g.Models.Cookies.GetCookies("userWeixinNO", weixinID);
    if (weixinID.Equals(""))
    {
        string key = HotelCloud.Common.HCRequest.GetString("key");
        string[] a = key.Split('@');
        weixinID = a[0];
        userWeiXinID = a[1];
    }
    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", weixinID);
    viewDic.Add("hId", hotelid);
    viewDic.Add("uwx", userWeiXinID);


    var db = ViewData["db"] as System.Data.DataTable;

    ViewData["cssUrl"] = System.Configuration.ConfigurationManager.AppSettings["cssUrl"].ToString();
    ViewData["jsUrl"] = System.Configuration.ConfigurationManager.AppSettings["jsUrl"].ToString();
 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>发票抬头</title>
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["jsUrl"] %>/css/booklist/mend-reset.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/new-style.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["jsUrl"] %>/css/booklist/Restaurant.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/fontSize.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/fontSize.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body>
    <!-- <>主体页面 -->
    <article class="full-page">	  
  
     <%Html.RenderPartial("HeaderA", viewDic);%>
  
		<!--//内容区-->
		<section class="show-body">

         			<section class="content2">
                     <p class="ca-nao-weak">发票抬头</p>
				     <div class="invo-header-names">

                     <% for (int i = 0; i < db.Rows.Count; i++)
                        { %>
                            
                        
                          <dl class="s-my-dl">
                              <dt><%=db.Rows[i]["name"].ToString()%></dt>
                              <dd>
                                  <div class="s-invoice fl  <%=db.Rows[i]["isdefault"].ToString()=="1"  ? "cur" : "" %>"  onclick="return DoFapiao(this,'default',<%=db.Rows[i]["Id"].ToString() %>,'<%=db.Rows[i]["userweixinId"].ToString() %>')" >
                                  <p><em></em></p>默认抬头</div>
                                  <div class="s-del fr"  onclick="return DoFapiao(this,'del',<%=db.Rows[i]["Id"].ToString() %>,'<%=db.Rows[i]["userweixinId"].ToString() %>')" >
                                  <span></span>删除</div>
                                  <div class="s-edit fr" onClick="javascript:window.location.href='/zhinengA/addfapiao/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>&Id=<%=db.Rows[i]["Id"].ToString() %>&uId=<%=db.Rows[i]["userweixinId"].ToString() %>'" ><span></span>编辑</div>
                              </dd>
                          </dl>

                              <%  } %>
                       
                     </div>
                     <!--invo-header-names end-->
                     <div class="uc__account-info">
                           <div class="submit-btn sp">
                                <input type="button" class="btn-save" value="添加抬头" onClick="javascript:window.location.href='/zhinengA/addfapiao/<%=hotelid %>?key=<%=weixinID %>@<%=userWeiXinID %>'" />
                           </div>
                     </div>
			</section>
        

        </section>
        </article>
 
    <script>

        $(".s-invoice").click(function () {
            //            $(".s-invoice").removeClass("cur");
            //            $(this).toggleClass("cur");
        });
        $(".s-del").click(function () {
            //            $(this).parents(".s-my-dl").remove()
        });


        //只能输入数字
        $(".phonenum-input").keyup(function () {
            this.value = this.value.replace(/[^\d]/g, '');
        })



        function DoFapiao(that, type, Id, uId) {

            if (type == "default" && $(that).hasClass("cur")) {

                return false;
            }

            $.ajax({
                url: '/zhinengA/AddEditFaPiao',
                type: 'post',
                data: { hotelId: '<%=hotelid %>', key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>', type: type, Id: Id, uId: uId },
                dataType: 'json',
                success: function (ajaxObj) {
                    if (ajaxObj.Status == 0) {


                        if (type == "del") {
                            $(that).parents(".s-my-dl").remove();
                        }

                        else {
                            $(".s-invoice").removeClass("cur");
                            $(that).toggleClass("cur");

                        }

                    }

                    else {
                        layer.msg(ajaxObj.Mess);
                    }
                }


            });

        }

 


    </script>
</body>
</html>
