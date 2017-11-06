<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<meta name="format-detection" content="telephone=no">
<!--自动将网页中的电话号码显示为拨号的超链接-->
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
<!--width宽度height高度，initial-scale初始的缩放比例，minimum-scale允许缩放到的最小比例，maximum-scale允许缩放到的最大比例，user-scalable是否可以手动缩放-->
<meta name="apple-mobile-web-app-capable" content="yes">
<!--IOS设备-->
<meta name="apple-touch-fullscreen" content="yes">
<!--IOS设备-->
<meta http-equiv="Access-Control-Allow-Origin" content="*">
<title>酒店点评</title>
<link type="text/css" rel="stylesheet" href="../../css/booklist/sale-date.css"/>
<link type="text/css" rel="stylesheet" href="../../css/booklist/fontSize.css"/>
    <link href="../../Scripts/webuploader/webuploader.css" rel="stylesheet" type="text/css" />
        <style>
        .webuploader-pick
        {
            background: none;
        }
    </style>
</head>
<body>
<section class="yu-bgw">
	     <div class="bg-Rwhite">
              <div class="ca-safe-per">
                    <div class="ca-want-say">
                          <textarea type="text" style="resize:none;" id="content" placeholder="产品满足你的期待吗？说说你的体验，分享给想买的他们吧！"></textarea>
                          <div class="ca-load-pht">
                               <ul>
                                    <li class="add-comment-pht">
                                        <i id="uploadbar"></i><span style="display:none;">添加图片</span><span><em>0</em>/5</span>
                                    </li>
                               </ul>
                          </div>
                          <!--ca-load-pht end-->
                    </div>
                    <!--ca-want-say end-->
              </div>
              <!--ca-safe-per end-->
         </div>
         <!--bg-Rwhite end-->
</section>
         <div class="bg-Rwhite">
               <div class="ca-safe-per">
                     <div class="ca-pf-good">
                          <h1><i class="type9"></i>酒店评分</h1>
                          <ul class="ca-pf-stars" id="Goods">
                               <li><span>卫生服务</span><i class="Star"></i><i class="Star"></i><i class="Star"></i><i class="Star"></i><i class="Star"></i></li>
                               <li><span>设施服务</span><i class="Star"></i><i class="Star"></i><i class="Star"></i><i class="Star"></i><i class="Star"></i></li></li>
                               <li><span>网络服务</span><i class="Star"></i><i class="Star"></i><i class="Star"></i><i class="Star"></i><i class="Star"></i></li></li>
                               <li><span>服务态度</span><i class="Star"></i><i class="Star"></i><i class="Star"></i><i class="Star"></i><i class="Star"></i></li></li>
                          </ul>
                          <!--ca-pf-stars end-->
                     </div>
                     <!--ca-pf-start end-->
               </div>
               <!--ca-safe-per end-->
         </div>
         <!--bg-Rwhite end-->
         <div class="ca-safe-per">
              <input type="submit" value="提交评价" class="btn-submit-star">
              <input type="hidden" id="hHotelID" value='<%=Convert.ToInt32(ViewData["hotelID"])%>'/>
              <input type="hidden" id="hOrderID" value='<%=Convert.ToInt32(ViewData["orderID"])%>'/>
              <input type="hidden" id="hUserWxID" value='<%=Convert.ToString(ViewData["userWeixinID"])%>'/>
              <input type="hidden" id="hHotelWxID" value='<%=Convert.ToString(ViewData["hotelWeixinID"])%>'/>
              <input type="hidden" id="hRoomType" value='<%=Convert.ToString(ViewData["roomType"])%>'/>
         </div>
<section>
</section>
<script type="text/javascript" src="../../Scripts/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="../../Scripts/fontSize.js"></script>
<script src="../../Scripts/webuploader/webuploader.js" type="text/javascript"></script>
<script src="../../Scripts/layer/layer.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {
        Comment();
    })
    //星星评分
    $("#Goods li i").on('click', function () {
        $(this).siblings().removeClass("Star")
        $(this).prevAll().addClass("Star")
        $(this).addClass("Star")
    })
    //删除图片
    $("body").on('click', '.ca-load-pht li .del', function () {
        $(this).parents("li").remove();
        var Plen = $(".ca-load-pht li").length
        var numEm = $(".add-comment-pht").find("em"); //.html(6 - Plen);
        numEm.html(numEm.html() * 1 - 1);
        if (Plen < 6) {
            $('#uploadbar input[type="file"]').removeAttr("disabled");
            $(".add-comment-pht").show();
        }
    });
    //上传图片
    var uploader = WebUploader.create({
        // 选完文件后，是否自动上传。
        auto: true,
        // swf文件路径
        swf: '../../Scripts/webuploader/Uploader.swf',
        // 文件接收服务端。
        server: '/Hotel/UploadImg?hotelID= <%=Convert.ToInt32(ViewData["hotelID"])%> ',
        // 选择文件的按钮。可选。
        // 内部根据当前运行是创建，可能是input元素，也可能是flash.
        //pick: '#filePicker',
        pick: '#uploadbar',
        // 只允许选择图片文件。
        accept: {
            title: 'Images',
            extensions: 'gif,jpg,jpeg,bmp,png',
            mimeTypes: 'image/jpg,image/jpeg,image/png'
        }
    });
    uploader.on('uploadSuccess', function (file, response) {//上传成功
        $('.add-comment-pht').before('<li><img src="' + response._raw.toString() + '"><p><b class="del"></b></p></li>');
        var Plen = $(".ca-load-pht li").length
        $(".add-comment-pht").find("em").html(Plen - 1);
        if (Plen == 6) {
            $('#uploadbar input[type="file"]').attr('disabled', 'disabled');
//            layer.msg("最多只能上传五张评价图片!");
            $(".add-comment-pht").hide();
        }
    });
    uploader.on('uploadError', function (file) {//上传失败
        layer.msg("上传出错!请稍后重试!");
    });
    //评价
    function Comment() {
        $('.btn-submit-star').on('click', function () {
            var hID = $('#hHotelID').val(); var oID = $('#hOrderID').val();
            var uWxID = $('#hUserWxID').val(); var hWxID = $('#hHotelWxID').val();
            var rType = $('#hRoomType').val(); var content = $('#content').val().trim();
            var hss = $('#Goods>li:eq(0)').find('i[class="Star"]').length;
            var fss = $('#Goods>li:eq(1)').find('i[class="Star"]').length;
            var nss = $('#Goods>li:eq(2)').find('i[class="Star"]').length;
            var ass = $('#Goods>li:eq(3)').find('i[class="Star"]').length;
            var imgs = "";
            $('.ca-load-pht ul>li>img').each(function () { imgs += $(this).attr("src") + "|" });
            if (content.length <= 0) {
                layer.msg("请输入评价内容!");
                return;
            }
            if (hID == '0' || oID == '0' || uWxID == '' || hWxID == '') {
                layer.msg("操作异常!请返回重试!");
                return false;
            }
            $('.btn-submit-star').attr('disabled', 'disabled');
            $.post('Comment', { HotelID: hID, OrderID: oID, UserWeixinID: uWxID,HotelWeixinID:hWxID,RoomType:rType, Content: content, Imgs: imgs, HealthServiceScore: hss, FacilityServiceScore: fss, NetworkServiceScore: nss, AttitudeServiceScore: ass }, function (data) {
                if (data.state == 0) {
                    layer.msg(data.msg, { icon: 1 });
                    setTimeout(function () {
                        location.href = '/Hotel/CommentList/' + hID;
                    }, 2000);
                } else {
                    layer.msg(data.msg, { icon: 2 });
                }
            });
        });
    }	
</script>
</body>
</html>
