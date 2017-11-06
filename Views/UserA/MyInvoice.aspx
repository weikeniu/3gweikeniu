<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    ViewDataDictionary viewDic = new ViewDataDictionary();
    viewDic.Add("weixinID", ViewData["weixinID"]);
    viewDic.Add("hId", ViewData["hId"]);
    viewDic.Add("uwx", ViewData["userWeiXinID"]);
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <title>发票明细</title>
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/sale-date.css" />
    <link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/new-style.css" />
    <link rel="stylesheet" href="http://css.weikeniu.com/css/booklist/mend-reset.css" />
    <script src="http://css.weikeniu.com/Scripts/jquery-1.8.0.min.js"></script>
    <script src="http://css.weikeniu.com/Scripts/fontSize.js"></script>
</head>
<body>
    <section class="loading-page" style="position: fixed; display: none">
			<div class="inner">
				<img src="http://css.weikeniu.com/images/loading-w.png" class="type1" />
				<img src="http://css.weikeniu.com/images/loading-n.png" />
			</div>
		</section>
    <!-- <>主体页面 -->
    <article class="full-page">
		<!--//侧边栏-->
		    <%Html.RenderPartial("HeaderA", viewDic);%>
		<!--//内容区-->
		<section class="show-body">
                  <section class="content2">
                  		
                  		<!--//发票明细-->
                    	<div class="ca-ivdetail-top">
	                        <a class="ca-return-icon fl" href="javascript:history.go(-1);"></a>
	                        <div class="hd-mx fr"><a href="javascript:void(0);"><i class="ico-hdmx i3"></i>发票明细</a></div>
						</div>
                    	<!--ca-ivdetail-top end-->
                    	<div class="ca-ivdetail-content" style="">
                            
                            <div class="ivdetail-table">
                                      <table cellpadding="0" cellspacing="0" border="0">
                                     
                                              <tbody id="data_content">


                                             <%--          <tr>
                                                           <td><div class="ca-small-time">周五<br/>1-01</div></td>
                                                           <td><div class="ca-by-begin"><span><i class="i1"></i></span>
                                                                    <dl>
                                                                          <dt>华艺酒店大堂会议厅</dt>
                                                                          <dd>陈木丰</dd>
                                                                     </dl>
                                                               </div>
                                                           </td>
                                                           <td align="right"><div class="ca-no-condition"><span>未开<br/></span><span class="ca-not-start">168.00</span></div></td>
                                                      </tr>--%>

                                                      <tr  class="copy" style="display:none" >
                                                           <td><div class="ca-small-time"><span class="p_week"></span><br/><span class="p_date"></span></div></td>
                                                           <td><div class="ca-by-begin"><span><i class="i1"></i></span>
                                                                    <dl>
                                                                          <dt class="p_name"></dt>
                                                                          <dd class="p_taxnum"></dd>
                                                                     </dl>
                                                               </div>
                                                           </td>
                                                           <td align="right"><div class="ca-no-condition"><span class="p_status"></span><br/><span class="ca-not-start p_fmoney"></span></div></td>
                                                      </tr>
                                                     
                                              </tbody>
                                      </table>
                            </div>
                          
                    	</div>


                        <div class="uc__storeValCard-details wu_data"  style="display:none">
						<div class="no-data">
							<img src="../../images/icon__no-invoice.png" />
							<h2>还没有发票明细</h2>
							<p>过段时间再来瞧瞧吧</p>
							<a class="back" href="javascript:history.go(-1);">返回</a>
						</div>
					</div>
                    	<!--ca-ivdetail-content end-->
                  </section>



		</section>    
	</article>


    <input type="hidden" id="cur_page" value="0" />
    <input type="hidden" id="cur_sumpage" value="1" />
    <script>


        $(function () {
            getMoreData();

        });

        var isEnd = false;

        function getMoreData() {
            if (isEnd) {

                return false;
            }

            var cur_page = parseInt($('#cur_page').val());
            var cur_sumpage = parseInt($('#cur_sumpage').val());

            if (cur_page >= cur_sumpage) {
                return false;
            }
            var tmp = {
                page: cur_page + 1,
                key: '<%=HotelCloud.Common.HCRequest.GetString("key")%>'
            };


            // layer.load();
            $(".loading-page").show();

            tmp.select = "";
            tmp.query = "";

            $.ajax({
                data: tmp,
                type: 'post',
                url: '/UserA/FetchMyInvoice',
                dataType: 'json'
            }).done(function (data) {
                if (data) {
                    var html = '';
                    if (data.data) {
                        data.data = $.parseJSON(data.data);


                        for (var i = 0; i < data.data.length; i++) {

                            var curr_data = $('#data_content .copy').clone(true).removeClass("copy").css("display", "");
                            $(curr_data).find(".p_week").text(getdatestr(data.data[i].Feedback4));
                            $(curr_data).find(".p_date").text(data.data[i].Feedback5);
                            $(curr_data).find(".p_name").text(data.data[i].Goods);
                            if (data.data[i].FType != null && data.data[i].FType != '') {
                                $(curr_data).find(".p_name").text(data.data[i].Goods + "(" + data.data[i].FType + ")");
                            }
                            $(curr_data).find(".p_taxnum").text(data.data[i].Feedback1);
                            $(curr_data).find(".p_fmoney").text(data.data[i].FMoney);

                            if (data.data[i].Status == 2) {
                                $(curr_data).find(".p_status").text("完成");
                                $(curr_data).find(".p_status").addClass("yu-orange");
                            }

                            else {
                                $(curr_data).find(".p_status").text("未开");

                            }
                            $("#data_content").append(curr_data);
                        }

                        $('#cur_page').val(data.page);
                        $('#cur_sumpage').val(data.pagesum);

                        if (data.count == 0 || data.page >= data.pagesum) {
                            isEnd = true;
                        }
                    }

                    if (isEnd) {

                        if (data.count == 0 && data.page == 1) {
                            $(".wu_data").show();
                        }

                        else {
                            $("#data_content").append('<p style="text-align:center;color:#aaa;padding:10px 0px 10px 0px;" id="nomore">没有更多了...</p>');

                        }

                    }

                    $(".loading-page").hide();
                    //  layer.closeAll();
                }

            });
        }





        $(".content2").scroll(function () {
            var scrollTop = $(this).scrollTop();
            var scrollHeight = $(".content2").get(0).scrollHeight;
            var windowHeight = $(this).height();
            var headerHeight = $("header").height();
            if (scrollTop + windowHeight + headerHeight >= scrollHeight) {
                getMoreData();
            }
        });

        function getdatestr(datestr) {
            var date = new Date(datestr);
            var weekary = { 0: '周日', 1: '周一', 2: '周二', 3: '周三', 4: '周四', 5: '周五', 6: '周六' };
            return weekary[date.getDay()];
        }

    </script>
</body>
</html>
