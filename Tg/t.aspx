<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="t.aspx.cs" Inherits="hotel3g.TuiGuang.Tuiguang" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <title></title>
    <link rel="stylesheet" type="text/css" href="css/new_file.css" />
    <meta name="format-detection" content="telephone=no">
    <!--自动将网页中的电话号码显示为拨号的超链接-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
    <meta name="apple-mobile-web-app-capable" content="yes">
    <!--IOS设备-->
    <meta name="apple-touch-fullscreen" content="yes">
    <!--IOS设备-->
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
</head>
<body>
    <form id="form1" runat="server">
    <header>
				<div class="top1">
					<h3>开启直销提升业绩
					<input type="button" class="b_shadow" id="k-yes" value="我要开通" />
				<input type="button" class="b_shadow1" id="k-no" value="不需要" />
					</h3>
				</div>
				
			</header>
    <div class="top2">
        <p>
            开启酒店直销-发展直销会员</p>
    </div>
    <table class="logo-tell">
        <tr>
            <th>
                <img src="img/images/tell_01.png" />
            </th>
            <th>
                <a href="tel:020-39431567">
                    <img src="img/images/tell_02.png" /></a>
            </th>
            <th>
                <img src="img/images/tell_03.png" />
            </th>
            <th>
                <a href="tel:15120922193">
                    <img src="img/images/tell_04.png" /></a>
            </th>
        </tr>
        <tr>
            <td>
                <img src="img/images/tell_05.png" />
            </td>
            <td>
                <a href="tel:020-39431558">
                    <img src="img/images/tell_06.png" /></a>
            </td>
            <td>
                <img src="img/images/tell_07.png" />
            </td>
            <td>
                <a href="tel:13751610893">
                    <img src="img/images/tell_08.png" /></a>
            </td>
        </tr>
    </table>
    <div class="box1">
        <img src="img/xs1.jpg" />
        <img src="img/xse-b.png" />
        <img src="img/yy1.png" />
        <img src="img/yjsx1.png" />
        <div class="lianxi">
            <p class="b-b">
                <img src="img/lxfs.png" /></p>
            <div class="box2">
                <p>
                    酒店:<input type="text" name="" id="h_hotel" placeholder="请填写酒店名称" /></p>
                <p>
                    姓名:<input type="text" name="" id="h_name" placeholder="请填写姓名" /></p>
                <p>
                    手机:<input type="text" name="" id="h_mobile" placeholder="请填写手机号码" /></p>
            </div>
            <p>
                <input type="button" id="btn_hotel" value="提交" class="anniu heise" /></p>
        </div>
 
        <div class="kt-no">
            <h3>
                意向反馈</h3>
            <div class="ma-c">
                <span><i class="i-1"></i>对直销无兴趣</span> <span><i class="i-1"></i>不信任</span><br />
                <span><i class="i-1"></i>已经做得不错</span> <span><i class="i-1"></i>无自主权</span><br />
                <input type="button" value="提交" class="anniu" id="btn_no" />
            </div>
        </div>
        <div class="kt-yes div_yes">
            <p>
                √提交成功<br />
                我们将在24小时内派专员跟您联系。</p>
        </div>
        <div class="kt-yes div_yj">
            <p>
                √提交成功<br />
                感谢您宝贵的意见。</p>
        </div>
        <script src="js/jquery-1.11.0.js" type="text/javascript" charset="utf-8"></script>
        <script src="js/js.js" type="text/javascript"></script>
        <script src="../Scripts/layer/layer.js" type="text/javascript"></script>
        <script>

            $("#k-yes").click(function () {
                $.ajax({
                    url: 'tguang.ashx',
                    type: 'post',
                    data: {
                        Id: '<%=Request.QueryString["r"] %>', type: "ok"
                    },
                    dataType: 'text',
                    success: function (ajaxObj) {

                        if (ajaxObj.indexOf("ok") >= 0) {
                            $(".div_yes").show();
                            setTimeout('$(".div_yes").hide();', 2000);

                        }


                        else {
                            layer.msg("提交失败");
                        }

                    }
                });

            });


            $("#k-no,#btn_no").click(function () {

                $(".kt-no").show();

                var reason = "";

                var isanniu = false;

                if ($(this).hasClass("anniu")) {

                    isanniu = true;
                    $(".ma-c  .cur").each(function (i, item) {
                        reason += $(item).parent().text() + ",";
                    });

                    if (reason == "") {

                        layer.msg("请填写理由");
                        return false;
                    }

                }

                $.ajax({
                    url: 'tguang.ashx',
                    type: 'post',
                    data: {
                        Id: '<%=Request.QueryString["r"] %>', reason: reason, type: "no"
                    },
                    dataType: 'text',
                    success: function (ajaxObj) {
                        if (ajaxObj.indexOf("ok") >= 0) {
                            if (isanniu) {
                                $(".kt-no").hide();
                                $(".div_yj").show();
                                setTimeout('$(".div_yj").hide()', 2000);
                            }
                        }

                        else {
                            layer.msg("提交失败");
                        }

                    }
                });

            });


            $("#btn_hotel").click(function () {

                if ($("#h_hotel").val().trim() == "") {

                    layer.msg("请请输入酒店名称");
                    return false;


                }

                if ($("#h_name").val().trim() == "") {

                    layer.msg("请输入姓名");
                    return false;

                }


                if ($("#h_mobile").val().trim().length != 11) {

                    layer.msg("手机号码格式不对");
                    return false;

                }



                $.ajax({
                    url: 'tguang.ashx',
                    type: 'post',
                    data: {
                        Id: '<%=Request.QueryString["r"] %>', hotelName: $("#h_hotel").val().trim(), userName: $("#h_name").val().trim(), tel: $("#h_mobile").val().trim(), type: "hotel"
                    },
                    dataType: 'text',
                    success: function (ajaxObj) {
                        if (ajaxObj.indexOf("ok") >= 0) {


                            $("#h_hotel").val("");
                            $("#h_name").val("");
                            $("#h_mobile").val("");

                            $(".div_yes").show();
                            setTimeout('$(".div_yes").hide()', 2000);

                        }

                        else {
                            layer.msg("提交失败");
                        }

                    }
                });



            });
        
        </script>
    </form>
</body>
</html>
