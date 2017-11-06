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
        no1num = RandomLuckyDrawDeatil.no1num;
        no2num = RandomLuckyDrawDeatil.no2num;
        no3num = RandomLuckyDrawDeatil.no3num;
        no0num = RandomLuckyDrawDeatil.no0num;
    }
    
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
        .stop, .drawnobtnviews, .paize-select, luckyusers
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
<% if (RandomLuckyDrawDeatil != null)
   { %>
<body style="background: rgb(91, 43, 127); overflow-x: hidden;">
    <div class="banner">
        <header style="padding-left: 50px; text-align: center"><span id="drawtitle"></span>   <span id="jindu"></span><span id="allnum"></span></header>
        <a href="<%=UserItem != null ? ViewData["userinfo"] : "javascript:void(0);"%>" class='my'>
        </a>
        <div class="turnplate" style="background-image: url('../../images/turnplate-bg.png');
            background-size: 100% 100%;">
            <canvas class="item" id="wheelcanvas" width="422px" height="422px"></canvas>
            <img class="pointer2" src="../../images/turnplate-pointer.png" />
            <%--        <div class="pointer3">--%>
            <%if (UserItem != null)
              {%>
            <img class="pointer3" id="weixinphoto" src="<%=UserItem.photo+"#"+DateTime.Now.ToString("yyyyMMddHHmmssfff") %>" />
            <%}
              else
              { %>
            <%--       <img id="weixinphoto" src="../../images/turnplate-pointer.png" />--%>
            <%}%>
            <%--   </div>--%>
            <div class="get-prize">
                报名人员不足!</div>
        </div>
    </div>
    <div class="tips">
        <% if (UserItem != null && RandomLuckyDrawDeatil.tel == UserItem.tel && RandomLuckyDrawDeatil.edate >= DateTime.Parse(DateTime.Now.ToString("yyyy-MM-dd HH:00:00")))
           { %>
        <div class="inner clickshow">
            点击抽奖
        </div>
        <input type="button" style="display: none" class="start" />
        <input type="button" style="display: none" class="stop" />
        <%-- <div class="inner stop">
            停止
        </div>--%>
        <%} %>
        <input type="button" style="display: none" class="pointer" />
        <input type="button" style="display: none" class="stopP" />
        <!-- <div class="prize-names">
			<ul>
				<li>xxxx获得二等奖</li>
				<li>xxxx获得二等奖</li>
				<li>xxxx获得二等奖</li>
				<li>xxxx获得二等奖</li>
			</ul>
		</div> -->
    </div>
    <section class="main-sec">
		<div class="m-title">
    <!--
    <h3>活动说明</h3>
    -->
    <img src="../../images/l3.png" />
    </div>
		<div class="einfo">
			<p>活动：<%=RandomLuckyDrawDeatil.title %></p>
            <p>时间：<%=RandomLuckyDrawDeatil.sdate.ToString("yyyy-MM-dd HH点") %> - <%=RandomLuckyDrawDeatil.edate.ToString("yyyy-MM-dd HH点") %><%=  RandomLuckyDrawDeatil.edate < DateTime.Parse(DateTime.Now.ToString("yyyy-MM-dd HH:00:00")) ? "(已结束)" : ""%></p>

			<p>内容：</p>
			<p><%=RandomLuckyDrawDeatil.intro %></p>
		</div>
	</section>
    <section class="main-sec">
		<div class="m-title"><img src="../../images/l2.png" /></div>
		<div class="einfo">
            <p>特等奖：<%=RandomLuckyDrawDeatil.no0 %></p>
			<p>一等奖：<%=RandomLuckyDrawDeatil.no1 %></p>
			<p>二等奖：<%=RandomLuckyDrawDeatil.no2 %></p>
			<p>三等奖：<%=RandomLuckyDrawDeatil.no3 %></p>
            
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
    <!--烟花效果-->
    <div id="yanhua" style="display: none;">
        <img src="../../images/daoshu/yanhua.gif" style="width: 300px;" />
    </div>
    <div class="mask paize-select">
        <div class="inner">
            <form>
            <div class="top-row">
                <span class="add-prize">+新增抽奖</span> <span class="close"></span>
            </div>
            <div class="prize-list">
                <ul class="prize-lv">
                    <li>
                        <label>
                            <input type="radio" id="aaa" name="prize-lv" value="100">
                            特等奖
                        </label>
                    </li>
                    <li>
                        <label>
                            <input type="radio" id="aaa" name="prize-lv" value="1">
                            一等奖
                        </label>
                    </li>
                    <li>
                        <label>
                            <input type="radio" name="prize-lv" value="2">
                            二等奖
                        </label>
                    </li>
                    <li>
                        <label>
                            <input type="radio" name="prize-lv" value="3">
                            三等奖
                        </label>
                    </li>
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
                            <input type="radio" value="100" name="prize-lv_">
                            特等奖
                        </label>
                    </li>
                    <li>
                        <label>
                            <input type="radio" value="1" name="prize-lv_">
                            一等奖
                        </label>
                    </li>
                    <li>
                        <label>
                            <input type="radio" value="2" name="prize-lv_">
                            二等奖
                        </label>
                    </li>
                    <li>
                        <label>
                            <input type="radio" value="3" name="prize-lv_">
                            三等奖
                        </label>
                    </li>
                    <li>
                        <label>
                            <input type="radio" value="4" name="prize-lv_">
                            四等奖
                        </label>
                    </li>
                    <li>
                        <label>
                            <input type="radio" value="5" name="prize-lv_">
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




</body>
<%}
   else
   { %>
<body>
    地址错误</body>
<%}%>
</html>
<%--<script type="text/javascript" src="js/jquery-1.10.2.js"></script>--%>
<script src="../../Scripts/jquery-1.8.0.min.js" type="text/javascript"></script>
<script src="../../Scripts/layer/layer.js" type="text/javascript"></script>
<script type="text/javascript" src="../../Scripts/awardRotate.js"></script>
<%--<script src="../../Scripts/m.hotel.com.core.min.js" type="text/javascript"></script>--%>
<%--<script
    src="../../Scripts/index.js" type="text/javascript"></script>--%>
<script type="text/javascript">
    $(function () {


       //开奖等级
       var drawno=2;
     

       var isnewdraw=false;

        var no1num = parseInt('<%=no1num %>');
        var no2num = parseInt('<%=no2num %>');
        var no3num = parseInt('<%=no3num %>');
        var no0num = parseInt('<%=no0num %>');

        var NotLuckyDrawUsers = null;
        var photoInterval = false; //是否开启轮播
        var luckyuser=null;
        var newdraw=true;
        var autoclick=false;
        
        var pthoonums=0;

        var ls=0;
        //获取参与开奖的人员
        function GetNotLuckyDrawUsers() {
            var drawid = '<%=ViewData["drawid"] %>';
            $.post("/MemberCard/GetNotLuckyDrawUsers", { drawid: drawid }, function (data, status)            {
                NotLuckyDrawUsers = data;
                pthoonums=data.count;
                photoIntervalView();
            });
        };
        //获取当前参与未获奖人员
        GetNotLuckyDrawUsers();

        //微信头像轮播
        function photoIntervalView() {
            if (NotLuckyDrawUsers != null && NotLuckyDrawUsers.count > 0) {
                var photos = eval(NotLuckyDrawUsers.list);
                //图片循环切换
                var index = setInterval(function () {
                    var index = Math.floor(Math.random() * (pthoonums - 1) + 1);
                    if (photoInterval) {
                        $("#weixinphoto").attr("src", photos[index].photo);
                    }
                }, 200);
            }
        }
          <% if (UserItem != null && RandomLuckyDrawDeatil.tel == UserItem.tel)
           { %>



           $(".sy").click(function(){
           var thisnum=parseInt($("#limitnum").val())
           var tag=$(this).hasClass("jian");
           if(tag){
           if(thisnum>1){
           thisnum--;
           }
           $("#limitnum").val(thisnum);
           }else{
           thisnum++;
           $("#limitnum").val(thisnum);
           }


           });

           $(".drawnobtn").click(function(){
           $(".mask").hide();
           var attr=$(this);
            var val=$(attr).hasClass("limit")?$('input[name=prize-lv_]:radio:checked').val():$('input[name=prize-lv]:radio:checked').val();
            drawno=parseInt(val==""?"0":val);

           if(drawno>0){
           

           var drawtitle="";
           switch (drawno)
            {
                case 1: drawtitle = "一等奖"; break;
                case 2: drawtitle = "二等奖"; break;
                case 3: drawtitle = "三等奖"; break;
                case 4: drawtitle = "四等奖"; break;
                case 5: drawtitle = "五等奖"; break;
                case 100: drawtitle = "特等奖"; break;
            }
            //s$("#drawtitle").text(drawtitle)

           layer.closeAll();
           setTimeout(function(){
           
            ls=0;
            var num=0;
            switch(drawno){
            case 1: num=no1num; break;
            case 2: num=no2num;  break;
            case 3: num=no3num;  break;
            case 100: num=no0num;  break;
            }



             if($(attr).hasClass("limit")){
                   isnewdraw=true;
                   var limitnum= $("#limitnum").val();
                   num=parseInt(limitnum);
             }else{
                   isnewdraw=false;
             };

            

            if(num>0&&num<NotLuckyDrawUsers.count){
           // $("#allnum").text(num>0?num:0);
            $(".inner").hide();
             for(var i=0;i<num;i++){
                   var ti=i+1;
                   var time=15000*i;
                   var index =  setTimeout(function(){
                   ls++;
                    layer.msg("当前第"+ls+"个 倒计时准备");
                    //$("#jindu").text(ls+"/");
                     $(".start").click();
                     setTimeout(function(){
                     //layer.msg("开始抽奖");
                     $(".stop").click();
                     if(ls==num){
                       $(".inner").show();
                       photoInterval=false;
                                }
                     },10000)
                   },time);
                      
             }
             }else{
            
                 layer.msg("奖项名额或抽奖人数不足!");
     };
           },500);
           }else{
            layer.msg("请选择奖项!");
           }

   });
     $(".prize-lv>li").on("click",function(){
    	$(this).addClass("cur").siblings().removeClass("cur");
    });

    $(".add-prize").click(function(){
		$(this).parents("form").hide().siblings("form").show();
		$(".checked-box").show();
	});

    $(".close").click(function(){
		$(".mask").hide();
     
	});

	$(".clickshow").click(function(){
		$(".mask.paize-select").show();
		$(".mask.paize-select>.inner").children("form").eq(0).show().siblings("form").hide();
	})

  $(".mask .inner").click(function(e){
		e.stopPropagation();
	});

$(".inner").click(function(){
	//$(".mask.paize-select").show();
////捕获页
// layer.open({
//  type: 1,
//  shade: 0.3,
//  title: false, //不显示标题
//  content: $('.mask.paize-select'), //捕获的元素，注意：最好该指定的元素要存放在body最外层，否则可能被    其它的相对元素所影响
//  cancel: function(){
//    //layer.msg('捕获就是从页面已经存在的元素上，包裹layer的结构', {time: 5000, icon:6});
//  }
//});

         
});


        //点击开奖修改开奖状态
        $(".start").click(function () {
              
                if (NotLuckyDrawUsers!=null&&NotLuckyDrawUsers.count >= 1) {
                $(".pointer").click();
               // $("#weixinphoto").attr("src", "../../images/daoshu/djs-bg.png"); 
                $("#weixinphoto").attr("src", "<%=UserItem!=null?UserItem.photo:"../../images/daoshu/djs-bg.png" %>");
                    //转动转盘;
                $(this).hide();
               // setTimeout(function () { $(".stop").show(); }, 5000);
               
                         var prem = { status: 1, drawid: '<%=ViewData["drawid"] %>' };
                        
                          //参加人员数目达到开奖条件
                        
                     $.post("/MemberCard/UpdateLuckyDrawStartStatus", prem, function (data, status) {                       
                              if (data.status == 1) {
                                       var tt=3;
                       //开奖倒计时
                       var djs=setInterval(function(){
                       if(tt>0){
                       var poc=tt!=4?"djs-"+tt+".png":"djs-bg.png";
                        $("#weixinphoto").attr("src", "../../images/daoshu/"+poc);
                        tt--;
                       }else{
                       //关闭倒计时
                        clearInterval(djs);
                        photoInterval = true;
                              }
                            },1000);   
                          }
                        });

            } else {
    
                photoInterval = false;
                //参加人员数目未达到开奖条件
                layer.msg("报名人数未达到开奖条件!");
                $(".stopP").click();
                }
            
        });

        //点击停止按钮 开始抽奖
        $(".stop").click(function () {
         
            var num=0;
            switch(drawno){
            case 1: num=no1num; break;
            case 2: num=no2num;  break;
            case 3: num=no3num;  break;
            case 100: num=no0num;  break;
            }

            $(this).hide();
            //setTimeout(function () { $(".start").show(); }, 2000);
            if (NotLuckyDrawUsers.count >= 1) {
           
           if(num>0||isnewdraw){
            GetLuckyUser();
           }else{ 
           layer.msg("名额不足");
            $(".stopP").click();
             photoInterval = false;
           }


           } else {
               layer.msg("参加人员数目未达到开奖条件");
                 window.clearInterval(mytime);
                 $(".stopP").click();
            };
          
        });

        //抽取
        function GetLuckyUser(){
           var drawid = '<%=ViewData["drawid"] %>';
            
                //达到开奖人数 随机获取中奖人
                $.post("/MemberCard/GetLuckyDrawUser", { drawno: drawno, drawid: drawid, maxnum: NotLuckyDrawUsers.count }, function (data, status) {
               
                    if (data.status == 2) {

                   
                       NotLuckyDrawUsers.count=NotLuckyDrawUsers.count-1;
                       if(data.userweixinid=='<%=userweixinid %>'){
                       //本人奖
                       //烟花显示位置
                         // var fworks = new Fireworks();     
                         layer.msg("恭喜您获奖了");
                       }else{
                       //非本人中奖
                        var msg = "恭喜" + data.name + "获得了" + data.drawtitle;
                        layer.msg(msg);
                        } 
                         $("#weixinphoto").attr("src", data.photo);
                          photoInterval = false;
                        $(".stopP").click();
                        GetLuckyDrawUsers();

                    } else if (data.status == 100) {
                        layer.msg(data.msg);
                        photoInterval = false;
                    }
                    $(".stopP").click();
                    photoInterval = false;
                    var num=0;
            switch(drawno){
            case 1: no1num--;  break;
            case 2: no2num--;  break;
            case 3: no3num--;  break;
            case 100: no0num--;  break;
            }
                });
        }

        <%}else{%>
        //非开奖人界面
        var drawstatus="0"; //开奖状态
        var djsstate=true;
        GetNotLuckyDrawUsers();
        <%  string path1 = string.Format("../../Config/LuckyDrawStatus/{0}.txt", RandomLuckyDrawDeatil.id); %>
       var path1='<%=path1 %>';

       var nonum=1;
       //处理逻辑
       function message(){
       
           var tt= setInterval(function(){
           if(djsstate){
            
                     if(newdraw&&drawstatus=="1"){
                 
                      
                     //$("#weixinphoto").attr("src", "../../images/daoshu/djs-bg.png");
                        $("#weixinphoto").attr("src", "<%=UserItem!=null?UserItem.photo:"../../images/daoshu/djs-bg.png" %>");
                           djsstate=false;
                           newdraw=false;

                        var tt=3;
                       //开奖倒计时
                       var djs=setInterval(function(){
                       if(tt>0){
                       var poc=tt!=4?"djs-"+tt+".png":"djs-bg.png";
                        $("#weixinphoto").attr("src", "../../images/daoshu/"+poc);
                        tt--;
                       }else{
                       //关闭倒计时
                        clearInterval(djs);
                        photoInterval=true;
                      
                     }
                 },900);
         }
         }
       if(drawstatus=="3"){
            
               newdraw=true;
               djsstate=true;
         //获取开奖结果
        if(thisdrawno!=drawno){
                      nonum=1;
                     }
         if(luckyuser==''){
          
         var datas=getdrawresult();
         var data=datas[0];
          $("#weixinphoto").attr("src", data.photo);
          luckyuser=data.photo;
          var drawtitle="";
           switch (data.drawno)
            {
                case 1: drawtitle = "一等奖"; break;
                case 2: drawtitle = "二等奖"; break;
                case 3: drawtitle = "三等奖"; break;
                case 4: drawtitle = "四等奖"; break;
                case 5: drawtitle = "五等奖"; break;
                case 100: drawtitle = "特等奖"; break;
            }
            
            $("#drawtitle").text(drawtitle);
              nonum++;
             if(data.userweixinid=='<%=userweixinid %>'){
                       //本人获奖

                      //var fworks = new Fireworks();
                       layer.msg("恭喜您获奖了");

                       }else{

                 //非本人获奖
                 var msg="恭喜"+data.name+"获得了"+drawtitle;
                 layer.msg(msg);
                   
                 }
           
            GetLuckyDrawUsers();
          } 
             }
         },300);
     
     
       };
       function getDrawStatus()
       {
       //获取开奖状态
        setInterval(function(){
         thisdrawno=drawno;
          try{
            var htmlobj=$.ajax({url:path1,async:false});
                 drawstatus=htmlobj.responseText;
                 }catch(e){
                 drawstatus=0;
                 }
                  if (drawstatus!="1") 
                 {
                  $(".stopP").click();
                  photoInterval=false;
                  }else{
                   
                  $('.pointer').click();
                  luckyuser='';
                  }
            
         },300);
       }
       function getdrawresult(){
       //获取最新开奖结果
        <% string path2 = string.Format("../../Config/LuckyDrawStatus/Result{0}.txt", RandomLuckyDrawDeatil.id); %>
        var resultpath='<%=path2 %>'
           try{
        var htmlobj=$.ajax({url:resultpath,async:false});
            return eval('['+htmlobj.responseText+']');
           }catch(e){
           return null;
           }        
       }
       setTimeout(function(){
       getDrawStatus();
       },2000);
       message();
        <%} %>

        //获取已获奖名单
        function GetLuckyDrawUsers() {
        
            var drawid = parseInt('<%=ViewData["drawid"] %>');
            if (drawid > 0) {
                $.post("/MemberCard/GetLuckyDrawUsers", { drawid: drawid }, function (data, status) {
                    if (data.count > 0) {
                        var html1 = "";
                        var html2 = "";
                        var html3 = "";
                        var html4 = "";
                        var html5 = "";
                        var html100 = "";
                        var json = eval(data.list);
                        for (var i = 0; i < json.length; i++) {
                            var item = json[i];
      switch(item.drawno){
                            case 1: html1 += '<p style="line-height:24px;height:24px;"><span class="fl">' + item.name + '获得了' + item.result + '</span><span class="fr">' + item.wintime + '</span></p>';
                           
                            break;
                             case 2: html2 += '<p style="line-height:24px;height:24px;"><span class="fl">' + item.name + '获得了' + item.result + '</span><span class="fr">' + item.wintime + '</span></p>';
                         
                             break;
                              case 3: html3 += '<p style="line-height:24px;height:24px;"><span class="fl">' + item.name + '获得了' + item.result + '</span><span class="fr">' + item.wintime + '</span></p>';
                        
                              break;
                               case 4: html4 += '<p style="line-height:24px;height:24px;"><span class="fl">' + item.name + '获得了' + item.result + '</span><span class="fr">' + item.wintime + '</span></p>';
                         
                               break;
                               case 5: html5 += '<p style="line-height:24px;height:24px;"><span class="fl">' + item.name + '获得了' + item.result + '</span><span class="fr">' + item.wintime + '</span></p>';
                          
                               break;
                               case 100: html100 += '<p style="line-height:24px;height:24px;"><span class="fl">' + item.name + '获得了' + item.result + '</span><span class="fr">' + item.wintime + '</span></p>';
                               break;

                            }

                        }
                        $(".luckyusers").empty();
                     
                        $(".html1").html('<header>一等奖</header>'+html1).show();
                        $(".html2").html('<header>二等奖</header>'+html2).show();
                        $(".html3").html('<header>三等奖</header>'+html3).show();
                        $(".html4").html('<header>四等奖</header>'+html4).show();
                        $(".html5").html('<header>五等奖</header>'+html5).show();
                        $(".html100").html('<header>特等奖</header>'+html100).show();



                        if(html1==""){
                        $(".html1").hide();
                        }
                         if(html2==""){
                        $(".html2").hide();
                        }

                         if(html3==""){
                        $(".html3").hide();
                        }
                         if(html4==""){
                        $(".html4").hide();
                        }
                          if(html5==""){
                        $(".html5").hide();
                        }
                          if(html100==""){
                        $(".html100").hide();
                        }

                    }
                });
            }
        }
        GetLuckyDrawUsers();
        $(".luckyusers").hide();
    });

    var turnplate = {
        restaraunts: [], 			//大转盘奖品名称
        colors: [], 				//大转盘奖品区块对应背景颜色
        outsideRadius: 170, 		//大转盘外圆的半径
        textRadius: 130, 			//大转盘奖品位置距离圆心的距离
        insideRadius: 68, 		//大转盘内圆的半径
        startAngle: 0, 			//开始角度

        bRotate: false				//false:停止;ture:旋转
    };

    $(document).ready(function () {
        var i = 0, j = 100,mytime=null;
        $(".mask,.get-prize,.pointer2").click(function () {
            $(".mask").hide();
            $(".get-prize").hide();
        })
        $(".mask.login .inner").click(function (e) {
            e.stopPropagation();
        });
//        $(".mask.login .close").click(function () {
//            $(".mask").hide();
//        });
        <% if(UserItem==null){%>
        $(".insert").click(function () {
            $(".mask.login").show();
        });
        <%} %>
        // 动态添加大转盘的奖品与奖品区域背景颜色
        // turnplate.restaraunts = ["50M免费流量包", "10闪币", "谢谢参与", "5闪币", "10M免费流量包", "20M免费流量包", "20闪币 ", "30M免费流量包", "100M免费流量包", "2闪币"];
        // turnplate.restaraunts = ["2246", "5614", "3390", "4499", "1718", "6677", "4945 ", "8745", "1111", "6068"];
        // turnplate.colors = ["#FFF4D6", "#FFFFFF", "#FFF4D6", "#FFFFFF","#FFF4D6", "#FFFFFF", "#FFF4D6", "#FFFFFF","#FFF4D6", "#FFFFFF"];

        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        turnplate.restaraunts = [];
        turnplate.colors = [];

        for (var i = 0; i < 16; i++) {
            turnplate.restaraunts[i] = "" + i;
        }
        for (var j = 0; j < turnplate.restaraunts.length; j++) {
            if (j % 2 == 0) {
                turnplate.colors[j] = "#FFF4D6";
            } else {
                turnplate.colors[j] = "#FFFFFF";
            }

        }
        console.log(turnplate.restaraunts)
        console.log(turnplate.colors)
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        
        var rotateTimeOut = function () {
            $('#wheelcanvas').rotate({
                angle: 0,
                animateTo: 2160,
                duration: 8000,
                callback: function () {
                    alert('网络超时，请检查您的网络设置！');
                }
            });


        };

        //旋转转盘 item:奖品位置; txt：提示语;
        var rotateFn = function (item, txt) {
            var angles = item * (360 / turnplate.restaraunts.length) - (360 / (turnplate.restaraunts.length * 2));
            if (angles < 270) {
                angles = 270 - angles;
            } else {
                angles = 360 - angles + 270;
            }
            $('#wheelcanvas').stopRotate();
            $('#wheelcanvas').rotate({
                angle: 0,
                animateTo: angles + 5000,
                duration: 80000,
                callback: function () {
                    // alert(txt);
                    //$(".mask.space").show();
                    //$(".get-prize").show();
                    turnplate.bRotate = !turnplate.bRotate;
                }
            });
        };


        function changeH() {
            // this.mytime=function(){
            // 	setInterval(function(){
            // 	i<3?i++:i=1;
            // 	$(".pointer3").html("<img src='images/h"+i+".jpg' />");		

            // 	},100)	
            // };
            // this.stoptime=function(){
            // 	i=3;
            // 	$(".pointer3").html("<img src='images/h"+i+".jpg' />");	
            // }
            window.clearInterval(mytime);
            mytime = window.setInterval(function () {
                if (j < 8000) {
                    j += 100;
                    i < 3 ? i++ : i = 1;
                    $(".pointer3").html("<img src='../../images/h" + i + ".jpg' />");
                } else {
                    i = 2;
                    $(".pointer3").html("<img src='../../images/h" + i + ".jpg' />");
                    window.clearInterval(mytime);
                }
                console.log(j)
            }, 1000);




        }

        $('.pointer').click(function () {
            j = 100;
            //changeH();
            if (turnplate.bRotate) return;

            turnplate.bRotate = !turnplate.bRotate;
            //获取随机数(奖品个数范围内)
            var item = rnd(1, turnplate.restaraunts.length);
            //奖品数量等于10,指针落在对应奖品区域的中心角度[252, 216, 180, 144, 108, 72, 36, 360, 324, 288]
            rotateFn(item, turnplate.restaraunts[item - 1]);
            /* switch (item) {
            case 1:
            rotateFn(252, turnplate.restaraunts[0]);
            break;
            case 2:
            rotateFn(216, turnplate.restaraunts[1]);
            break;
            case 3:
            rotateFn(180, turnplate.restaraunts[2]);
            break;
            case 4:
            rotateFn(144, turnplate.restaraunts[3]);
            break;
            case 5:
            rotateFn(108, turnplate.restaraunts[4]);
            break;
            case 6:
            rotateFn(72, turnplate.restaraunts[5]);
            break;
            case 7:
            rotateFn(36, turnplate.restaraunts[6]);
            break;
            case 8:
            rotateFn(360, turnplate.restaraunts[7]);
            break;
            case 9:
            rotateFn(324, turnplate.restaraunts[8]);
            break;
            case 10:
            rotateFn(288, turnplate.restaraunts[9]);
            break;
            } */
            console.log(item);
        });


        $(".stopP").click(function () {
            window.clearInterval(mytime);
            j = 100;
            i = 2;
            //$(".pointer3").html("<img src='../../images/h" + i + ".jpg' />");
            $('#wheelcanvas').rotate({
                duration: 100,
                callback: function () {
                    //$(".mask.space").show();
                    //$(".get-prize").show();
                    turnplate.bRotate = !turnplate.bRotate;
                }
            });
        })
    });

    function rnd(n, m) {
        var random = Math.floor(Math.random() * (m - n + 1) + n);
        return random;

    }


    //页面所有元素加载完毕后执行drawRouletteWheel()方法对转盘进行渲染
    window.onload = function () {
        drawRouletteWheel();
    };

    function drawRouletteWheel() {
        var canvas = document.getElementById("wheelcanvas");
        if (canvas.getContext) {
            //根据奖品个数计算圆周角度
            var arc = Math.PI / (turnplate.restaraunts.length / 2);
            var ctx = canvas.getContext("2d");
            //在给定矩形内清空一个矩形
            ctx.clearRect(0, 0, 422, 422);
            //strokeStyle 属性设置或返回用于笔触的颜色、渐变或模式  
            ctx.strokeStyle = "#FFBE04";
            //font 属性设置或返回画布上文本内容的当前字体属性
            ctx.font = '16px Microsoft YaHei';
            for (var i = 0; i < turnplate.restaraunts.length; i++) {
                var angle = turnplate.startAngle + i * arc;
                ctx.fillStyle = turnplate.colors[i];
                ctx.beginPath();
                //arc(x,y,r,起始角,结束角,绘制方向) 方法创建弧/曲线（用于创建圆或部分圆）    
                ctx.arc(211, 211, turnplate.outsideRadius, angle, angle + arc, false);
                ctx.arc(211, 211, turnplate.insideRadius, angle + arc, angle, true);
                ctx.stroke();
                ctx.fill();
                //锁画布(为了保存之前的画布状态)
                ctx.save();

                //----绘制奖品开始----
                ctx.fillStyle = "#E5302F";
                var text = turnplate.restaraunts[i];
                var line_height = 17;
                //translate方法重新映射画布上的 (0,0) 位置
                ctx.translate(211 + Math.cos(angle + arc / 2) * turnplate.textRadius, 211 + Math.sin(angle + arc / 2) * turnplate.textRadius);

                //rotate方法旋转当前的绘图
                ctx.rotate(angle + arc / 2 + Math.PI / 2);

                /** 下面代码根据奖品类型、奖品名称长度渲染不同效果，如字体、颜色、图片效果。(具体根据实际情况改变) **/
                if (text.indexOf("M") > 0) {//流量包
                    var texts = text.split("M");
                    for (var j = 0; j < texts.length; j++) {
                        ctx.font = j == 0 ? 'bold 20px Microsoft YaHei' : '16px Microsoft YaHei';
                        if (j == 0) {
                            ctx.fillText(texts[j] + "M", -ctx.measureText(texts[j] + "M").width / 2, j * line_height);
                        } else {
                            ctx.fillText(texts[j], -ctx.measureText(texts[j]).width / 2, j * line_height);
                        }
                    }
                } else if (text.indexOf("M") == -1 && text.length > 6) {//奖品名称长度超过一定范围 
                    text = text.substring(0, 6) + "||" + text.substring(6);
                    var texts = text.split("||");
                    for (var j = 0; j < texts.length; j++) {
                        ctx.fillText(texts[j], -ctx.measureText(texts[j]).width / 2, j * line_height);
                    }
                } else {
                    //在画布上绘制填色的文本。文本的默认颜色是黑色
                    //measureText()方法返回包含一个对象，该对象包含以像素计的指定字体宽度
                    ctx.fillText(text, -ctx.measureText(text).width / 2, 0);
                }

                //添加对应图标
                if (text.indexOf("闪币") > 0) {
                    var img = document.getElementById("shan-img");
                    img.onload = function () {
                        ctx.drawImage(img, -15, 10);
                    };
                    ctx.drawImage(img, -15, 10);
                } else if (text.indexOf("谢谢参与") >= 0) {
                    var img = document.getElementById("sorry-img");
                    img.onload = function () {
                        ctx.drawImage(img, -15, 10);
                    };
                    ctx.drawImage(img, -15, 10);
                }
                //把当前画布返回（调整）到上一个save()状态之前 
                ctx.restore();
                //----绘制奖品结束----
            }
        }
    }

</script>
