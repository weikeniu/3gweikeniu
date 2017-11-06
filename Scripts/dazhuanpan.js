

//头像循环切换开关
var photoInterval = false;

//获取参与开奖的人员
var NotLuckyDrawUsers =null
function GetNotLuckyDrawUsers(id) {
    var drawid = id;
    $.post("/MemberCard/GetNotLuckyDrawUsers", { drawid: drawid }, function (data, status) {
        NotLuckyDrawUsers = data;
        maxnum = data.count;
    });
};


//获取开奖用户列表
function GetLuckyDrawUsers(drawid) {

 
    if (parseInt(drawid) > 0) {
        $.post("/MemberCard/GetLuckyDrawUsers", { drawid: drawid }, function (data, status) {
            if (data.count > 0) {
                $(".mask2").hide();
                var html1 = "";
                var html2 = "";
                var html3 = "";
                var html4 = "";
                var html5 = "";
                var html100 = "";
                var json = eval(data.list);
                for (var i = 0; i < json.length; i++) {
                    var item = json[i];
                    $(".bb").hide();
                    switch (item.drawno) {

                        case 1: html1 += '<p style="line-height:24px;height:24px;"><span class="fl">' + item.name  + '</span><span class="fr">' + item.wintime + '</span></p>';
                            $(".gift1").show();
                            break;
                        case 2: html2 += '<p style="line-height:24px;height:24px;"><span class="fl">' + item.name  + '</span><span class="fr">' + item.wintime + '</span></p>';
                            $(".gift2").show();
                            break;
                        case 3: html3 += '<p style="line-height:24px;height:24px;"><span class="fl">' + item.name  + '</span><span class="fr">' + item.wintime + '</span></p>';
                            $(".gift3").show();
                            break;
                        case 4: html4 += '<p style="line-height:24px;height:24px;"><span class="fl">' + item.name  + '</span><span class="fr">' + item.wintime + '</span></p>';

                            break;
                        case 5: html5 += '<p style="line-height:24px;height:24px;"><span class="fl">' + item.name +  '</span><span class="fr">' + item.wintime + '</span></p>';

                            break;
                        case 100: html100 += '<p style="line-height:24px;height:24px;"><span class="fl">' + item.name + '</span><span class="fr">' + item.wintime + '</span></p>';                       $(".gift100").show();
                            break;

                    }

                }
                $(".luckyusers").empty();

                $(".html1").html('<header>一等奖</header>' + html1).show();
                $(".html2").html('<header>二等奖</header>' + html2).show();
                $(".html3").html('<header>三等奖</header>' + html3).show();
                $(".html4").html('<header>四等奖</header>' + html4).show();
                $(".html5").html('<header>五等奖</header>' + html5).show();
                $(".html100").html('<header>特等奖</header>' + html100).show();

                if (html1 == "") {
                    $(".html1").hide();
                }
                if (html2 == "") {
                    $(".html2").hide();
                }

                if (html3 == "") {
                    $(".html3").hide();
                }
                if (html4 == "") {
                    $(".html4").hide();
                }
                if (html5 == "") {
                    $(".html5").hide();
                }
                if (html100 == "") {
                    $(".html100").hide();
                }

            }
        });
    }
}


//开关转盘
function zhuanpan(message) {

    if (message) {
        $('.pointer').click();
    } else {
        $('.stopP').click();
    }
    //开关头像切换
    photoInterval = message;
}

//弹出窗
$(".prize-lv>li").on("click", function () {
    $(this).addClass("cur").siblings().removeClass("cur");
});
$(".add-prize").click(function () {
    $(this).parents("form").hide().siblings("form").show();
    $(".checked-box").show();
});

$(".close").click(function () {
    $(".mask").hide();

});

$(".clickshow").click(function () {
    $(".mask.paize-select").show();
    $(".mask.paize-select>.inner").children("form").eq(0).show().siblings("form").hide();
})

$(".mask .inner").click(function (e) {
    e.stopPropagation();
});


//加减数字
$(".sy").click(function () {
    var thisnum = parseInt($("#limitnum").val())
    var tag = $(this).hasClass("jian");
    if (tag) {
        if (thisnum > 1) {
            thisnum--;
        }
        $("#limitnum").val(thisnum);
    } else {
        thisnum++;
        $("#limitnum").val(thisnum);
    }


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
    var i = 0, j = 100, mytime = null;
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