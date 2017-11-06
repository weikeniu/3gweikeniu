<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    hotel3g.Repository.RandomLuckyDrawClass RandomLuckyDrawDeatil = ViewData["RandomLuckyDrawDeatil"] as hotel3g.Repository.RandomLuckyDrawClass;
    hotel3g.Repository.RandomLuckyDrawUserClass UserItem =
    ViewData["UserItem"] as hotel3g.Repository.RandomLuckyDrawUserClass;
    string NotLuckyUsers = ViewData["NotLuckyUsers"] as string;
    NotLuckyUsers = string.IsNullOrEmpty(NotLuckyUsers) ? "[]" : NotLuckyUsers;
    Page.Title = RandomLuckyDrawDeatil.title;
    string userweixinid = UserItem != null ? UserItem.userweixinid : "";
    string no1num = string.Empty;
    string no2num = string.Empty;
    string no3num = string.Empty;
    string no0num = string.Empty;
    if (RandomLuckyDrawDeatil != null)
    {
        no1num = string.IsNullOrEmpty(RandomLuckyDrawDeatil.no1num) ? "0" : RandomLuckyDrawDeatil.no1num;
        no2num = string.IsNullOrEmpty(RandomLuckyDrawDeatil.no2num) ? "0" : RandomLuckyDrawDeatil.no2num;
        no3num = string.IsNullOrEmpty(RandomLuckyDrawDeatil.no3num) ? "0" : RandomLuckyDrawDeatil.no3num;
        no0num = string.IsNullOrEmpty(RandomLuckyDrawDeatil.no0num) ? "0" : RandomLuckyDrawDeatil.no0num;
    }
    DateTime thistime = DateTime.Parse(DateTime.Now.ToString("yyyy-MM-dd HH:00:00"));
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>抽奖</title>
    <link href="../../css/dazhuanpan/style.css?t=<%=DateTime.Now.ToString("yyyyMMddHHmmsssff") %>"
        rel="stylesheet" type="text/css" />
    <style type="text/css">
        .stop, .drawnobtnviews, .paize-select, .luckyusers
        {
            display: none;
        }
        #canvas-container canvas
        {
            position: relative;
            z-index: 1100;
        }
        .drawnobtnviews
        {
            width: 120px;
        }
        .drawnobtn
        {
            padding: 5px;
            border-bottom: #ddd solid 1px;
            cursor: pointer;
            font-size: 18px;
            text-align: center;
        }
        .drawnobtn:hover
        {
            background: #f80;
        }
        .luckyusers
        {
            margin-bottom: 10px;
        }
    </style>
</head>
<body style="background: rgb(91, 43, 127); overflow-x: hidden;">
    <% if (RandomLuckyDrawDeatil != null)
       { %>
    <div class="banner">
        <header style="padding-left: 50px; text-align: center"><span id="drawtitle"></span>   <span id="jindu"></span><span id="allnum"></span></header>
        <a href="<%=UserItem != null ? ViewData["userinfo"] : "javascript:void(0);"%>" class='my' style="display:none;">
        </a>
        <div class="turnplate" style="background-image: url('../../images/turnplate-bg.png');
            background-size: 100% 100%;width:38%;margin-top:-19%">
            <canvas class="item" id="wheelcanvas" width="422px" height="422px"></canvas>
            <img class="pointer2" src="../../images/turnplate-pointer.png" />
            <img class="pointer3" id="weixinphoto" src="../../images/daoshu/logo_03.png" />
        </div>
    </div>
    <div class="tips">
        <% if (UserItem != null && UserItem.tel == RandomLuckyDrawDeatil.tel && RandomLuckyDrawDeatil.edate >= thistime)
           { %>
        <div class="inner clickshow">
            点击抽奖
        </div>
        <%} %>
        <input type="button" style="display: none" class="start" />
        <input type="button" style="display: none" class="stop" />
        <input type="button" style="display: none" class="pointer" />
        <input type="button" style="display: none" class="stopP" />
    </div>
    <section class="main-sec">
		<div class="m-title">
    <!--
    <h3>活动说明</h3>
    -->
    <img src="../../images/l3.png" />
    </div>
		<div class="einfo">
			<p>活动：<%=RandomLuckyDrawDeatil.title%></p>
            <p>时间：<%=RandomLuckyDrawDeatil.sdate.ToString("yyyy-MM-dd HH点")%> - <%=RandomLuckyDrawDeatil.edate.ToString("yyyy-MM-dd HH点")%><%=  RandomLuckyDrawDeatil.edate < DateTime.Parse(DateTime.Now.ToString("yyyy-MM-dd HH:00:00")) ? "(已结束)" : ""%></p>

			<p>内容：</p>
			<p><%=RandomLuckyDrawDeatil.intro%></p>
		</div>
	</section>
    <section class="main-sec">
		<div class="m-title"><img src="../../images/l2.png" /></div>
		<div class="einfo">
            <p class="bb">神秘礼品</p>

            <p class="gift100" style="display:none">特等奖：<%=RandomLuckyDrawDeatil.no0 %></p>
			<p class="gift1" style="display:none">一等奖：<%=RandomLuckyDrawDeatil.no1 %></p>
			<p class="gift2" style="display:none">二等奖：<%=RandomLuckyDrawDeatil.no2 %></p>
			<p class="gift3" style="display:none">三等奖：<%=RandomLuckyDrawDeatil.no3 %></p>
            
   <%--         【<%=RandomLuckyDrawDeatil.no1num %>名】
            【<%=RandomLuckyDrawDeatil.no2num %>名】
            【<%=RandomLuckyDrawDeatil.no3num %>名】
            【<%=RandomLuckyDrawDeatil.no0num %>名】--%>
		</div>
	</section>
    <section class="main-sec">
		<div class="m-title"><img src="../../images/l1.png" /></div>
	    <div class="einfo luckyusers html100">

		</div>


		<div class="einfo luckyusers html1">

		</div>

        <div class="einfo luckyusers html2">

		</div>

        <div class="einfo luckyusers html3">

		</div>

        <div class="einfo luckyusers html4">

		</div>

        <div class="einfo luckyusers html5">

		</div>
	</section>
    <div class="mask paize-select" style="display:none">
        <div class="inner">
            <form>
            <div class="top-row">
                <span class="add-prize">+新增抽奖</span> <span class="close"></span>
            </div>
            <div class="prize-list">
                <ul class="prize-lv">
                    <%if (int.Parse(no0num) > 0)
                      { %>
                    <li>
                        <label>
                            <input type="radio" num="<%=no0num %>" name="prize-lv" value="100" />
                            特等奖
                        </label>
                    </li>
                    <%} %>
                    <%if (int.Parse(no1num) > 0)
                      { %>
                    <li>
                        <label>
                            <input type="radio" num="<%=no1num %>" name="prize-lv" value="1" />
                            一等奖
                        </label>
                    </li>
                    <%} %>
                    <%if (int.Parse(no2num) > 0)
                      { %>
                    <li>
                        <label>
                            <input type="radio" num="<%=no2num %>" name="prize-lv" value="2" />
                            二等奖
                        </label>
                    </li>
                    <%} %>
                    <%if (int.Parse(no3num) > 0)
                      { %>
                    <li>
                        <label>
                            <input type="radio" num="<%=no3num %>" name="prize-lv" value="3" />
                            三等奖
                        </label>
                    </li>
                    <%} %>
                </ul>
            </div>
            <input type="button" value="点击抽奖" class="drawnobtn" />
            </form>
            <form>
            <div class="checked-box">
                <span class="close"></span>
                <ul>
                    <li>
                        <label>
                            <input type="radio" num="0" value="100" name="prize-lv_" />
                            特等奖
                        </label>
                    </li>
                    <li>
                        <label>
                            <input type="radio" num="0" value="1" name="prize-lv_" />
                            一等奖
                        </label>
                    </li>
                    <li>
                        <label>
                            <input type="radio" num="0" value="2" name="prize-lv_" />
                            二等奖
                        </label>
                    </li>
                    <li>
                        <label>
                            <input type="radio" num="0" value="3" name="prize-lv_" />
                            三等奖
                        </label>
                    </li>
                    <li>
                        <label>
                            <input type="radio" num="0" value="4" name="prize-lv_" />
                            四等奖
                        </label>
                    </li>
                    <li>
                        <label>
                            <input type="radio" num="0" value="5" name="prize-lv_" />
                            五等奖
                        </label>
                    </li>
                    <li class="sp">
                        <div class="row">
                            <span>抽取</span> <span class="sy jia">+</span>
                            <input type="text" id="limitnum" value="1" />
                            <span class="sy jian">-</span> <span>个名额</span>
                        </div>
                    </li>
                    <li class="sp">
                        <input type="button" value="抽奖" class="drawnobtn limit" /></li>
                </ul>
            </div>
            </form>
        </div>
    </div>
<%--    <div class="mask space" id="canvas-container">
    </div>
    <div id="gui" style="">
    </div>--%>




    <% }
       else
       { %>
    活动不存在！
    <%} %>


<div class="mask2" style="display:none;z-index: 9999">
		<div style="width: 100%;text-align: center;background:rgba(0,0,0,0.5);color:#fff;font:14px/24px microsoft yahei,simhei;margin-top:30%;height:18%;padding-top: 31%">抽奖尚未开始<br>在此可观看抽奖过程</div>
	</div>
</body>
</html>
<script src="../../Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
<script src="../../Scripts/layer/layer.js" type="text/javascript"></script>
<script type="text/javascript" src="../../Scripts/awardRotate.js"></script>
<script src="../../Scripts/dazhuanpan.js" type="text/javascript"></script>
<script>
    //当前可参与抽奖的人数
    var maxnum = 0;
</script>
<script src="../../Scripts/index.js" type="text/javascript"></script>
<script type="text/javascript"> 

    $(function () {
   
        



        var drawno = 0;
        var limitnum = 0; //连续开奖次数限制
        var LuckyDrawUsers; //开奖用户列表
        var drawid ='<%=ViewData["drawid"] %>'; //奖项id
            var status = 0; //开奖状态 0待开奖 1正在开奖 3获取开奖结果
        /*控制端*/

        <% 
        if (UserItem != null && UserItem.tel == RandomLuckyDrawDeatil.tel && RandomLuckyDrawDeatil.edate >= thistime)
        { %>
         $(".mask2").hide();

        /*循环执行逻辑*/

        $(".drawnobtn").click(function () {
       
     

            //判断是否为手动输入
            var ishand = $(this).hasClass("limit");
            if (ishand) {
                //是手动 将输入数字赋值给 limitnum
                limitnum = parseInt($("#limitnum").val());
                $('input[name=prize-lv_]:radio:checked').attr("num",limitnum);

            } else {
                //未手动 将后台数据赋值给 limitnum
                var num = $('input[name=prize-lv]:radio:checked').attr("num");
                limitnum = parseInt(num);
            }
            if(limitnum>0&& maxnum>=limitnum){
            maxnum--;
            //获取开奖奖项编号
            var drawno_ = ishand ? $('input[name=prize-lv_]:radio:checked').val() : $('input[name=prize-lv]:radio:checked').val();

            drawno = parseInt(drawno_);
            //判断本次开奖是否有效
            if (drawno > 0) {
                $(".close").click();
                var kaijiangnum = 0;
                //有效开奖 进入开奖逻辑
                for (var i = 0; i < limitnum; i++) {

                    //按循环限制循环开奖
                    var s = 15 * i + 1;
                    //s 秒执行一次

                    //倒计时开始抽奖
                    setTimeout(function () {
                        //单次开奖隐藏开奖按钮
                        $(".clickshow").hide();
                        kaijiangnum++;
                        //标识已开奖
                        kaijiang();

                        //等待开奖 时间 5秒
                        setTimeout(function () {
                            //layer.msg("第" + kaijiangnum + "轮!开始抽奖");
                            //获取后端开奖
                            getkaijiangresult(ishand);

                        }, 10 * 1000);

                        if (i + 1 == limitnum) {
                            //循环完毕关闭 循环计时器
                            layer.msg("开奖完毕!");
                            //循环完毕 将该奖项剩余次数清空为零

                        } else {
                            ///开始 等待抽奖用于 效果展示 添加
                            layer.msg("第" + kaijiangnum + "轮!");
                        }

                    }, s * 1000)




                }

            } else {
                layer.msg("请选择奖项!")
            }
            }else{
                layer.msg("人数不足");
            }
            
            
        });

        //后端抽奖逻辑
        function getkaijiangresult(ishand) {
            var drawid = '<%=ViewData["drawid"] %>';
            var prem = { drawid: drawid, drawno: drawno };
            var prizelv_ = parseInt($('input[name=prize-lv_]:radio:checked').attr("num"));
            var prizelv = parseInt($('input[name=prize-lv]:radio:checked').attr("num"));

            try {
            //异步获取开奖结果
            $.post('/MemberCard/GetLuckyDrawUserNew', prem, function (data, status) {

                if (data.status == 2) {
               
                    //当前剩余次数 -1
                    if (ishand) {
                        $('input[name=prize-lv_]:radio:checked').attr("num",prizelv_ - 1);
                        if (prizelv - 1 == 0) {
                            $('input[name=prize-lv_]:radio:checked').parent("label").parent("li[class=cur]").hide();
                            //一轮执行完毕 获取一次中奖名单
                            $(".clickshow").show();
                        }
                    } else {
                        $('input[name=prize-lv]:radio:checked').attr("num",prizelv - 1);
                        if (prizelv - 1 == 0) {
                            $('input[name=prize-lv]:radio:checked').parent("label").parent("li[class=cur]").hide();
                            //一轮执行完毕 获取一次中奖名单
                            $(".clickshow").show();
                        }
                    }

                    //开奖结束判断获奖人是否是 本人
                    if (data.userweixinid == '<%=userweixinid %>') {
                        //本人获奖 设置效果
                        var msg = "恭喜您获得了" + data.title;
                        layer.msg(msg);

                    } else {
                        //其他人获奖 简要提示
                        var msg = "恭喜" + data.name + "获得了" + data.title;
                        layer.msg(msg);
                    }
                    if (ishand){
                    $(".clickshow").show();
                    }
                    GetLuckyDrawUsers(drawid);
                    $("#weixinphoto").attr("src", data.photo);
                } else if (data.status == 100) {
                    layer.msg(data.msg);
                }

                zhuanpan(false);
            })
            }catch(e){
            layer.msg("可人数不足");
            zhuanpan(false);

            }


        };
        //表示 已开奖
        function kaijiang() {
            var prem = { status: 1, drawid: '<%=ViewData["drawid"] %>' };
            $.post("/MemberCard/UpdateLuckyDrawStartStatus", prem, function (data, status) {
                if (data.status == 1) {
                    //倒计时效果 尽量拉近与客户端显示时间点
                    zhuanpan(false);
                
                    var tt = 3;
                    //开奖倒计时
                    var djs = setInterval(function () {

                        if (tt > 0) {
                            var poc = tt != 4 ? "djs-" + tt + ".png" : "djs-bg.png";
                            $("#weixinphoto").attr("src", "../../images/daoshu/" + poc);
                            tt--;
                        } else {
                            //关闭倒计时
                            clearInterval(djs);
                            zhuanpan(true);
                       
                        }
                    }, 1000);
                    
                }
            });
        }

        <%}else{%>
        
           $(".mask").click(function(){
		if(!$(this).hasClass("stop1")){
			$(".mask").hide();
			$(".get-prize").hide();			
		}
	})
          /*用户端*/
    
        var oldname='';
        var isnew =true;
        //实时轮询获取 开奖状态
        function getstatus() {
           var index= setInterval(function () {

                //定时获取 开奖状态
                $.post('/MemberCard/GetLuckyDrawStatusById?drawid=' + drawid, function (data, status) {
                status=data.status;
                if(data.status==1){
                 $(".mask2").hide();
                }

                if(data.status==1&&isnew){
                
                    isnew=false;
                 //倒计时效果 尽量拉近与客户端显示时间点
                     zhuanpan(false);
                      var tt = 3;
                      //开奖倒计时
                      var djs = setInterval(function () {

                        if (tt > 0) {
                            var poc = tt != 4 ? "djs-" + tt + ".png" : "djs-bg.png";
                            $("#weixinphoto").attr("src", "../../images/daoshu/" + poc);
                            tt--;
                        } else {
                            //关闭倒计时
                            clearInterval(djs);
                            zhuanpan(true);
                        }
                    }, 1000);
                }else {
                //不是开奖状态 关闭转盘
                 //zhuanpan(false);
                }
                 if(data.status==2){

                  
                      zhuanpan(false);
                 //可以读取开奖结果
             
                 if(oldname!=data.name){
                 isnew=true;
                     isnew=true;
                 oldname=data.name;
                  //开奖结束判断获奖人是否是 本人
                    if (data.userweixinid == '<%=userweixinid %>') {
                        //本人获奖 设置效果
                        var msg = "恭喜您获得了" + data.title;
                        layer.msg(msg);

                    } else {
                        //其他人获奖 简要提示
                        var fworks = new Fireworks();
                        var msg = "恭喜" + data.name + "获得了" + data.title;
                        layer.msg(msg);
                    }
                    

                    $("#weixinphoto").attr("src", data.photo);
                     GetLuckyDrawUsers(drawid);
                    }

                 } 


                });

            }, 300);
        }
     
        setTimeout(function(){
        getstatus();
        },2000);
        
    
        <%} %>

        /*通用*/
        //拉取获奖用户列表
       

  
             GetNotLuckyDrawUsers(drawid);
             GetLuckyDrawUsers(drawid);

  

        photoIntervalView();
        function photoIntervalView() {
            var index = setInterval(function () {
                if (NotLuckyDrawUsers != null && NotLuckyDrawUsers.count > 0) {
                    var photos = eval(NotLuckyDrawUsers.list);
                    //图片循环切换

                    var index = Math.floor(Math.random() * (NotLuckyDrawUsers.count-1) + 1);
                    if (photoInterval) {
                        $("#weixinphoto").attr("src", photos[index].photo);
                    }
                }
            }, 200);

        }

    })

   
</script>
