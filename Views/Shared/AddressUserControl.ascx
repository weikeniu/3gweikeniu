<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/sale-date.css"/>
    <link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/Restaurant.css"/>
    <script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
    <script src="<%=System.Configuration.ConfigurationManager.AppSettings["jsUrl"] %>/Scripts/layer/layer.js" type="text/javascript"></script>
 <% 
     string key = HotelCloud.Common.HCRequest.GetString("key");
     string memberphone = "";
     List<hotel3g.Models.OrderAddress> list = new List<hotel3g.Models.OrderAddress>();
     if (key.Contains('@'))
     {
         list=hotel3g.Models.DishOrderLogic.GetAddressList(key.Split('@')[1]);
         memberphone=hotel3g.Models.DishOrderLogic.GetMemberPhone(key.Split('@')[1]);
     }
    //List<hotel3g.Models.OrderAddress> list = (List<hotel3g.Models.OrderAddress>)ViewData["list"];
    hotel3g.Models.OrderAddress model=list.Find(a => a.isSelected == true);
    model = model == null ? new hotel3g.Models.OrderAddress() : model;
    
    string strphone = "";
                     %>

<style> .cross{ display:none;} </style>
<section class="yu-tpad10">
			<div class="yu-bgw yu-lpad10 yu-bmar10">
            <input type="hidden" id="code_msg" value="aayualigncdd"/>
            <input type="hidden" id="code_phone" value=""/>
			<div class="yu-grid yu-h60 yu-line60">
				<p class="yu-w50 yu-font14 yu-rmar10">联系人</p>
				<div class="yu-overflow yu-bor bbor">
					<div class="yu-grid yu-alignc yu-h60 name-bar">
						<p class="yu-overflow">
							<input type="text" id="LinkMan" name="LinkMan" placeholder="请输入名称" class="input-type2 name-input" value='<%=model.LinkMan %>'/>
						</p>
						<p class="close-type1"></p>
					</div>
					
				</div>
			</div>
			<div class="yu-grid yu-bor bbor yu-alignc" <%=list.Count>0?"style='display:block'":"style='display:none'" %>>
				<p class="yu-w50 yu-rmar10">&nbsp;</p>
				<div class="yu-overflow select-list yu-tbpad10 name-select" >
					<% 
                        foreach (var item in list)
                        {
                            strphone += item.LinkPhone + "@";
            
                    %>
                      <p class="yu-bor1 bor <%=item.isSelected?"cur":"" %>">
                        <%=item.LinkMan%>
                        <input type="hidden" class="lm" value="<%=item.LinkMan %>"/>
                        <input type="hidden" class="ph" value="<%=item.LinkPhone %>"/>
                        <input type="hidden" class="ad" value="<%=item.Address %>"/>
                        <input type="hidden" class="rm" value="<%=item.RoomNo %>"/>
                        <input type="hidden" class="adtype" value="<%=item.addressType %>"/>
                        <input type="hidden" class="adadress" value="<%=item.kuaidiAddress %>"/>
                      </p>
                   <%
                        }
                       
                       strphone += string.IsNullOrEmpty(memberphone) ? "" : "@" + memberphone;
                        %>
				</div>
			</div>

            <div class="yu-grid yu-h60 yu-line60 yu-bor bbor yu-rpad10 yu-alignc">
				<p class="yu-w50 yu-font14 yu-rmar10">电话</p>
				<div class="yu-overflow">
					<div class="yu-grid yu-alignc yu-rmar10">
						<p class="yu-overflow">
							<input type="number"  id="LinkPhone" onkeyup="phonekeyup(this.value)" name="LinkPhone"  placeholder="请输入手机号" class="input-type2" value='<%=model.LinkPhone %>'  maxlength="11"/>
						</p>
						<p class="close-type1"></p>
					</div>
				</div>
				<p class="yzm-btn type1 yu-bor1 bor" id="btn-getvalicode" onclick="getValidateCode()">获取验证码</p>
                <p class="yzm-btn type1 yu-bor1 bor" id="btn-valicodetime" style="display:none"></p>
			</div>
            
			<div class="yu-grid yu-h60 yu-line60 yu-rpad10 yu-alignc" id="div-validate-code">
				<p class="yu-w50 yu-font14 yu-rmar10">验证码</p>
				<p class="yu-overflow">
					<input type="number" placeholder="输入验证码" class="input-type2" id="valiCode" name="valiCode"  value='' />
				</p>
				<p class="close-type1"></p>
			</div>
          

            <div class="yu-grid yu-h60 yu-line60 yu-bor bbor yu-rpad10" id="div_typeSelect">
				<p class="yu-font14 yu-rmar10 yu-overflow">收货地址</p>
                <input type="hidden" name="address-type" id="address-type" value="1"/>
				<div class="address-select">
					<label class="cur">
						酒店
						<input type="radio" name="aaa" id="rdo1" value="1" checked="checked"/>
						<span class="ico"></span>
					</label>
					<label id="otheraddressid">
						其他
						<input type="radio" name="aaa" id="rdo2" value="2"/>
						<span class="ico"></span>
					</label>
				</div>
			</div>

			<div class="yu-grid yu-h60 yu-line60 yu-bor bbor yu-rpad10 dish-address">
				<p class="yu-w60 yu-font14 yu-rmar10">当前酒店</p>
				<div class="yu-overflow">
					<input type="text" placeholder="请输入送餐地址"  id="address" name="address" class="input-type2" value='<%=ViewData["hotelName"]%>' readonly="readonly"/>
				</div>
			</div>
			<div class="yu-grid yu-h60 yu-line60 yu-rpad10 yu-alignc dish-address">
				<p class="yu-w60 yu-font14 yu-rmar10">地址</p>
				<p class="yu-overflow">
					<input type="text" placeholder="地址位置"  id="RoomNo" name="RoomNo" class="input-type2" value='<%=model.RoomNo %>'/>
				</p>
				<p class="close-type1"></p>
			</div>

            <div class="hide-row express-type yu-bgfc kuaidi-address" style="display:none">
				<div class="yu-grid yu-h60 yu-line60 yu-bor bbor yu-rpad10">
					<p class="yu-w50 yu-font14 yu-rmar10">地址</p>
					<div class="yu-overflow">
						<input type="text" id="kdaddress" placeholder="请输入收货地址" class="input-type2 yu-bgfc" value="<%=model.kuaidiAddress %>">
					</div>
				</div>
			</div>
			</div>
			
</section>
<!--酒店开启地址-->
<script>
    var st = '<%=model.addressType %>';
    var strphone = '<%=strphone %>';
    $(function () {
        if (strphone != '') {
            $("#btn-getvalicode,#div-validate-code").addClass("cross");
        } else {
            $("#btn-getvalicode,#div-validate-code").removeClass("cross");
        }

        if (st == '2') {
            $('#address-type').val(2);
            $("#rdo1").attr("checked", false);
            $("#rdo2").attr("checked", true);
            $("#rdo1").parent().removeClass("cur");
            $("#rdo2").parent().addClass("cur");
            $('.kuaidi-address').show();
            $('.dish-address').hide();

        }
        if (st == '1') {
            $('#address-type').val(1);
            $("#rdo1").attr("checked", true);
            $("#rdo2").attr("checked", false);
            $("#rdo1").parent().addClass("cur");
            $("#rdo2").parent().removeClass("cur");
            $('.kuaidi-address').hide();
            $('.dish-address').show();
        }


        //选择收货地址
        $(".address-select label").on("click", function () {
            $(this).addClass("cur").siblings().removeClass("cur");
            if ($(this).index() == 0) {
                $(".kuaidi-address").hide();
                $(".dish-address").show();
                $("#address-type").val(1);

                $("#kdaddress").val('');
            } else {
                $(".kuaidi-address").show();
                $(".dish-address").hide();
                $("#address-type").val(2);

                //$("#address").val('');
                $("#RoomNo").val('');
            }
        });

        //姓名选择
        $(".name-select").children("p").on("click", function () {
            $(this).addClass("cur").siblings("p").removeClass("cur");
            $(".name-input").parent().siblings(".close-type1").fadeIn();

            $(".name-input").val($(this).children(".lm").val());
            $("#LinkPhone").val($(this).children(".ph").val());
            $("#code_phone").val($(this).children(".ph").val());
            var t = $(this).children(".adtype").val();
            $("#address-type").val(t);
            if (t == "1") { //酒店
                //$("#address").val($(this).children(".ad").val());
                $("#RoomNo").val($(this).children(".rm").val());
                $("#kdaddress").val('');

                $(".kuaidi-address").hide();
                $(".dish-address").show();
                $("#rdo1").attr("checked", true);
                $("#rdo2").attr("checked", false);
                $("#rdo1").parent().addClass("cur");
                $("#rdo2").parent().removeClass("cur");
            } else {
                //$("#address").val('');
                $("#RoomNo").val('');
                $("#kdaddress").val($(this).children(".adadress").val());

                $(".kuaidi-address").show();
                $(".dish-address").hide();
                $("#rdo1").attr("checked", false);
                $("#rdo2").attr("checked", true);
                $("#rdo1").parent().removeClass("cur");
                $("#rdo2").parent().addClass("cur");
            }


            $("#btn-getvalicode,#div-validate-code").addClass("cross");

        })
        //出现close
        $(".input-type2").on("keyup", function () {
            if ($(this).val() != "") {
                $(this).parent().siblings(".close-type1").fadeIn();
            } else {
                $(this).parent().siblings(".close-type1").fadeOut();
            }
        });
        $(".close-type1").on("click", function () {
            $(this).fadeOut().siblings(".yu-overflow").children(".input-type2").val("");
            if ($(this).parent().hasClass("name-bar")) {
                $(".name-select").children().removeClass("cur");
            }
        });





    })


   


    function phonekeyup(v) {
        var F = false;
        var arr = strphone.split('@');
        for (var i = 0; i < arr.length; i++) {
            if (arr[i] == v) {
                F = true;
                break;
            }
        }
        v = v.replace(/\D/gi, "");
        $("#LinkPhone").val(v);
        if (F) {
            $("#btn-getvalicode,#div-validate-code").addClass("cross");
        } else {
            $("#btn-getvalicode,#div-validate-code").removeClass("cross");

        }
    }


    //获取验证码
    var temp = null;
    function getValidateCode() {
        var p = $('#LinkPhone').val();
        //var a = '/^((//(//d{3}//))|(//d{3}//-))?13//d{9}|15[89]//d{8}$/' ;
        //if( p.length!=11||!p.match(a) ){
        if (p.length != 11) {
            layer.msg("请输入正确的手机号码");
            return false;
        }
        if (p != "") {
            $.post("/DishOrder/GetValidateCode/?phone=" + p, function (data) {
                if (data.error == 1) {
                    $("#code_msg").val(data.message);
                    $("#code_phone").val(data.phone);
                    SetTime(120);
                    temp = data;
                } else {
                    layer.msg(data.message);
                }
            });
        }
    }

    function SetTime(TotalSeconds) {
        if (TotalSeconds >= 0) {
            $("#btn-getvalicode").hide();
            $("#btn-valicodetime").show();
            $("#btn-valicodetime").html(TotalSeconds);
            setTimeout(function () { SetTime(TotalSeconds - 1) }, 1000);
        }
        else //超时
        {
            $("#btn-getvalicode").show();
            $("#btn-valicodetime").hide();
            $("#code_msg").val('123abc');
        }
    }


    function validate() {
        
        var name = $('#LinkMan').val();
        var phone = $('#LinkPhone').val();
        var address = $("#address").val();
        var room = $('#RoomNo').val();

        var kdaddress = $('#kdaddress').val(); //快递地址
        var c1 = $("#valiCode").val();
        var c2 = $("#code_msg").val();

        var type = $("#address-type").val();
        if (type == "1") {
            if (name != '' && phone != '' && room != "") {//酒店
                var h = $("#btn-getvalicode").hasClass("cross");
                if (!h && c1 == "") { return false; }
                if (c1 != c2 && !h) {
                    if (c2 == '123abc') {
                        layer.msg("验证码无效，请重新获取验证码！");
                    } else {
                        layer.msg("请输入正确的验证码！");
                    }
                    return false;
                }
                var p = $("#code_phone").val();
                if (phone != p && !h) {
                    layer.msg("手机号与验证手机号不一致！");
                    return false;
                 }
            } else {
                layer.msg("请填写联系人/电话/酒店房号 ！");
                return false;
            }
        }
        else if (type == "2") {
            if (name != '' && phone != '' && kdaddress != "" && type == "2") {//快递
                var h = $("#btn-getvalicode").hasClass("cross");
                if (!h && c1 == "") { return false; }
                if (c1 != c2 && !h) {
                    if (c2 == '123abc') {
                        layer.msg("验证码无效，请重新获取验证码！");
                    } else {
                        layer.msg("请输入正确的验证码！");
                    }
                    return false;
                }
                var p = $("#code_phone").val();
                if (phone != p && !h) {
                    layer.msg("手机号与验证手机号不一致！");
                    return false;
                }
            } else {
                layer.msg("请填写联系人/电话/地址 ！");
                return false;
            }
        } else {
            layer.msg("请填选择收货地址！");
            return false;
        }

        return true;
     }

</script>