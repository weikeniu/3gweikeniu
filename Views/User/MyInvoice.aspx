<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%
    ViewDataDictionary jdata = new ViewDataDictionary();
    jdata.Add("weixinID", ViewData["weixinID"]);
    jdata.Add("hId", ViewData["hId"]);
    jdata.Add("uwx", ViewData["userWeiXinID"]);


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
    <title>发票记录</title>
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/sale-date.css" />
    <link type="text/css" rel="stylesheet" href="<%=ViewData["cssUrl"] %>/css/booklist/patch.css" />
    <script type="text/javascript" src="<%=ViewData["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script src="<%=ViewData["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
</head>
<body>
    <header class="yu-bor bbor">
 	<a href="javascript:history.go(-1);" class="back"><div class="new-l-arr"></div></a> 	
 	发票记录
 </header>
    <section class="yu-tpad120r wu_data" style="display: none">
	<div class="no-r-ico"></div>
	<p class="yu-c77 yu-f28r yu-textc ">暂无发票记录</p>
</section>
    <dl class="hb-list" id="data_content">
        <dd class="yu-bor bbor yu-bgw  yu-font14 copy" style="display: none">
            <a href="javascript:;" class="yu-grid yu-greys">
                <div class="yu-rmar10">
                    <p class="p_week">
                    </p>
                    <p class="p_date">
                    </p>
                </div>
                <div class="yu-overflow sp">
                    <div class="yu-grid">
                        <span class="fp-ico"></span>
                        <div class="yu-overflow">
                            <p class="p_name">
                            </p>
                            <p class="p_taxnum">
                            </p>
                        </div>
                    </div>
                </div>
                <div class="yu-textr">
                    <p class="p_status">
                    </p>
                    <p class="yu-black p_fmoney">
                    </p>
                </div>
            </a>
        </dd>
    </dl>
    <section class="loading-page" style="position: fixed; display: none">
			<div class="inner">
				<img src="http://css.weikeniu.com/images/loading-w.png" class="type1" />
				<img src="http://css.weikeniu.com/images/loading-n.png" />
			</div>
		</section>
    <input type="hidden" id="cur_page" value="0" />
    <input type="hidden" id="cur_sumpage" value="1" />
    <%Html.RenderPartial("Footer", jdata); %>
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
                url: '/User/FetchMyInvoice',
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
                            if (data.data[i].FType !=null &&  data.data[i].FType != '' ) {
                                $(curr_data).find(".p_name").text(data.data[i].Goods + "(" + data.data[i].FType + ")");
                            }
                            $(curr_data).find(".p_taxnum").text(data.data[i].Feedback1);
                            $(curr_data).find(".p_fmoney").text(data.data[i].FMoney);

                            if (data.data[i].Status == 2) {
                                $(curr_data).find(".p_status").text("完成");
                                $(curr_data).find(".p_status").addClass("yu-blue");
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


        $(window).scroll(function () {
            var scrollTop = $(this).scrollTop();
            var scrollHeight = $(document).height();
            var windowHeight = $(this).height();
            if (scrollTop + windowHeight == scrollHeight) {
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
