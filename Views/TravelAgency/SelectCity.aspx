<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
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
<title>搜索</title>
<link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/sale-date.css"/>
<link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/travel.css"/>
<link type="text/css" rel="stylesheet" href="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/css/booklist/font/iconfont.css"/>
<script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/Scripts/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=System.Configuration.ConfigurationManager.AppSettings["cssUrl"] %>/Scripts/fontSize.js"></script>
</head>
<body class="yu-bgw">
<section class="yu-lpad20r yu-tpad40r">
	<dl class="yu-bmar40r">
		<dt class="yu-c77 yu-f26r yu-bmar30r">我的位置</dt>
		<dd class="yu-grid select-item yu-flex-w-w">
			<p>丽江</p>
		</dd>
	</dl>
	<dl>
		<dt class="yu-c77 yu-f26r yu-bmar30r">热门</dt>
		<dd class="yu-grid select-item yu-flex-w-w select-item">
			<p>丽江</p>
			<p>北京</p>
			<p>上海</p>
			<p>杭州</p>
			<p>高雄</p>
			<p>台北</p>
			<p>香港</p>
			<p>澳门</p>
			<p>厦门</p>
			<p>武汉</p>
			<p>惠州</p>
			<p class="cur">广州</p>
			<p>深圳</p>
			<p>珠海</p>
			<p>佛山</p>
			<p>桂林</p>
		</dd>
	</dl>
</section>
<section class="letter">
	<dl>
		<dt id="a">A</dt>
		<dd>
			<p class="yu-bor bbor">鞍山</p>
			<p class="yu-bor bbor">安吉（湖州）</p>
			<p class="yu-bor bbor">安庆</p>
			<p class="yu-bor bbor">安顺市</p>
			<p class="yu-bor bbor">澳门</p>
		</dd>
		<dt  id="b">B</dt>
		<dd>
			<p class="yu-bor bbor">北京</p>
			<p class="yu-bor bbor">北戴河（秦皇岛）</p>
			<p class="yu-bor bbor">保定</p>
			<p class="yu-bor bbor">包头</p>
			<p class="yu-bor bbor">本溪</p>
			<p class="yu-bor bbor">蚌埠</p>
			<p class="yu-bor bbor">滨州</p>
			<p class="yu-bor bbor">北海</p>
			<p class="yu-bor bbor">百色</p>
			<p class="yu-bor bbor">宝鸡</p>
		</dd>
		<dt  id="c">C</dt>
		<dd>
			<p class="yu-bor bbor">承德</p>
			<p class="yu-bor bbor">沧州</p>
			<p class="yu-bor bbor">昌黎（秦皇岛）</p>
			<p class="yu-bor bbor">长治</p>
			<p class="yu-bor bbor">赤峰</p>
			<p class="yu-bor bbor">长春</p>
			<p class="yu-bor bbor">长白山池北</p>
			<p class="yu-bor bbor">常州</p>
			<p class="yu-bor bbor">常熟（苏州）</p>
			<p class="yu-bor bbor">慈溪（宁波）</p>
			<p class="yu-bor bbor">长沙</p>
			<p class="yu-bor bbor">郴州</p>
			<p class="yu-bor bbor">潮州</p>
			<p class="yu-bor bbor">成都</p>
		</dd>
		<dt  id="d">D</dt>
		<dd>
			<p class="yu-bor bbor">大同</p>
			<p class="yu-bor bbor">大连</p>
			<p class="yu-bor bbor">丹东</p>
			<p class="yu-bor bbor">大庆</p>
			<p class="yu-bor bbor">德清</p>
			<p class="yu-bor bbor">东营</p>
			<p class="yu-bor bbor">德州</p>
			<p class="yu-bor bbor">登封（郑州）</p>
			<p class="yu-bor bbor">东莞</p>
			<p class="yu-bor bbor">德阳</p>
			<p class="yu-bor bbor">达州</p>
			<p class="yu-bor bbor">大邑（成都）</p>
			<p class="yu-bor bbor">都江堰青城山（成都）</p>
			<p class="yu-bor bbor">大理</p>
			<p class="yu-bor bbor">敦煌</p>
		</dd>
		<dt  id="e">E</dt>
		<dd>
			<p class="yu-bor bbor">鄂尔多斯</p>
			<p class="yu-bor bbor">额尔古纳（呼伦贝尔）</p>
			<p class="yu-bor bbor">恩施</p>
			<p class="yu-bor bbor">恩平</p>
			<p class="yu-bor bbor">峨眉山</p>
		</dd>
		<dt  id="f">F</dt>
		<dd>
			<p class="yu-bor bbor">抚顺</p>
			<p class="yu-bor bbor">阜阳</p>
			<p class="yu-bor bbor">福州</p>
			<p class="yu-bor bbor">凤凰（湘西）</p>
			<p class="yu-bor bbor">佛山</p>
		</dd>
		<dt  id="g">G</dt>
		<dd>
			<p class="yu-bor bbor">赣州</p>
			<p class="yu-bor bbor">广州</p>
			<p class="yu-bor bbor">桂林</p>
			<p class="yu-bor bbor">广元</p>
			<p class="yu-bor bbor">贵阳</p>
		</dd>
		<dt  id="h">H</dt>
		<dd>
			<p class="yu-bor bbor">衡水</p>
			<p class="yu-bor bbor">邯郸</p>
			<p class="yu-bor bbor">呼和浩特</p>
			<p class="yu-bor bbor">呼伦贝尔（海拉尔）</p>
			<p class="yu-bor bbor">葫芦岛</p>
			<p class="yu-bor bbor">哈尔滨</p>
			<p class="yu-bor bbor">淮安</p>
			<p class="yu-bor bbor">杭州</p>
			<p class="yu-bor bbor">海宁</p>
			<p class="yu-bor bbor">湖州</p>
			<p class="yu-bor bbor">横店</p>
			<p class="yu-bor bbor">合肥</p>
			<p class="yu-bor bbor">黄山</p>
			<p class="yu-bor bbor">淮南</p>
			<p class="yu-bor bbor">宏村（黄山）</p>
			<p class="yu-bor bbor">衡阳</p>
			<p class="yu-bor bbor">惠州</p>
			<p class="yu-bor bbor">河源</p>
			<p class="yu-bor bbor">海口</p>
			<p class="yu-bor bbor">汉中</p>
		</dd>
		<dt  id="j">J</dt>
		<dd>
			<p class="yu-bor bbor">晋中</p>
			<p class="yu-bor bbor">晋城</p>
			<p class="yu-bor bbor">锦州</p>
			<p class="yu-bor bbor">吉林</p>
			<p class="yu-bor bbor">江阴（无锡）</p>
			<p class="yu-bor bbor">吉林</p>
			<p class="yu-bor bbor">金华</p>
			<p class="yu-bor bbor">嘉兴</p>
			<p class="yu-bor bbor">九华山（池州）</p>
			<p class="yu-bor bbor">晋江</p>
			<p class="yu-bor bbor">九江</p>
			<p class="yu-bor bbor">景德镇</p>
			<p class="yu-bor bbor">济南</p>
			<p class="yu-bor bbor">济宁</p>
			<p class="yu-bor bbor">即墨（青岛）</p>
			<p class="yu-bor bbor">焦作</p>
			<p class="yu-bor bbor">荆州</p>
			<p class="yu-bor bbor">揭阳</p>
			<p class="yu-bor bbor">江门</p>
			<p class="yu-bor bbor">九寨沟</p>
			<p class="yu-bor bbor">嘉峪关</p>
		</dd>
		<dt  id="k">K</dt>
		<dd>
			<p class="yu-bor bbor">昆山（苏州）</p>
			<p class="yu-bor bbor">开封</p>
			<p class="yu-bor bbor">开平</p>
			<p class="yu-bor bbor">凯里（黔东南）</p>
			<p class="yu-bor bbor">昆明</p>
		</dd>
		<dt  id="l">L</dt>
		<dd>
			<p class="yu-bor bbor">廊坊</p>
			<p class="yu-bor bbor">临汾</p>
			<p class="yu-bor bbor">连云港</p>
			<p class="yu-bor bbor">临安（杭州）</p>
			<p class="yu-bor bbor">丽水</p>
			<p class="yu-bor bbor">六安</p>
			<p class="yu-bor bbor">龙岩</p>
			<p class="yu-bor bbor">庐山（九江）</p>
			<p class="yu-bor bbor">临沂</p>
			<p class="yu-bor bbor">聊城</p>
			<p class="yu-bor bbor">洛阳</p>
			<p class="yu-bor bbor">柳州</p>
			<p class="yu-bor bbor">乐山</p>
			<p class="yu-bor bbor">丽江</p>
			<p class="yu-bor bbor">拉萨</p>
			<p class="yu-bor bbor">兰州</p>
		</dd>
		<dt  id="m">M</dt>
		<dd>
			<p class="yu-bor bbor">牡丹江</p>
			<p class="yu-bor bbor">马鞍山</p>
			<p class="yu-bor bbor">茂名</p>
			<p class="yu-bor bbor">梅州</p>
			<p class="yu-bor bbor">绵阳</p>
		</dd>
		<dt  id="n">N</dt>
		<dd>
			<p class="yu-bor bbor">南戴河（秦皇岛）</p>
			<p class="yu-bor bbor">南京</p>
			<p class="yu-bor bbor">南通</p>
			<p class="yu-bor bbor">宁波</p>
			<p class="yu-bor bbor">宁海（宁波）</p>
			<p class="yu-bor bbor">南浔（湖州）</p>
			<p class="yu-bor bbor">南昌</p>
			<p class="yu-bor bbor">南阳</p>
			<p class="yu-bor bbor">南宁</p>
			<p class="yu-bor bbor">南充</p>
		</dd>
		<dt  id="p">P</dt>
		<dd>
			<p class="yu-bor bbor">平遥（晋中）</p>
			<p class="yu-bor bbor">盘锦</p>
			<p class="yu-bor bbor">莆田</p>
			<p class="yu-bor bbor">蓬莱（烟台）</p>
			<p class="yu-bor bbor">攀枝花</p>
		</dd>
		<dt  id="q">Q</dt>
		<dd>
			<p class="yu-bor bbor">秦皇岛</p>
			<p class="yu-bor bbor">齐齐哈尔</p>
			<p class="yu-bor bbor">千岛湖（杭州）</p>
			<p class="yu-bor bbor">泉州</p>
			<p class="yu-bor bbor">青岛</p>
			<p class="yu-bor bbor">曲阜（济宁）</p>
			<p class="yu-bor bbor">清远</p>
			<p class="yu-bor bbor">钦州</p>
			<p class="yu-bor bbor">琼海（博鳌）</p>
		</dd>
		<dt  id="r">R</dt>
		<dd>
			<p class="yu-bor bbor">瑞安（温州）</p>
			<p class="yu-bor bbor">日照</p>
			<p class="yu-bor bbor">荣成（威海）</p>
			<p class="yu-bor bbor">乳山（威海）</p>
			<p class="yu-bor bbor">瑞丽（德宏州）</p>
		</dd>
		<dt  id="s">S</dt>
		<dd>
			<p class="yu-bor bbor">上海</p>
			<p class="yu-bor bbor">石家庄</p>
			<p class="yu-bor bbor">沈阳</p>
			<p class="yu-bor bbor">苏州</p>
			<p class="yu-bor bbor">宿迁</p>
			<p class="yu-bor bbor">绍兴</p>
			<p class="yu-bor bbor">上饶市</p>
			<p class="yu-bor bbor">三清山（上饶）</p>
			<p class="yu-bor bbor">商丘</p>
			<p class="yu-bor bbor">十堰</p>
			<p class="yu-bor bbor">汕头</p>
			<p class="yu-bor bbor">深圳</p>
			<p class="yu-bor bbor">韶关</p>
			<p class="yu-bor bbor">汕尾</p>
			<p class="yu-bor bbor">三亚</p>
		</dd>
		<dt  id="t">T</dt>
		<dd>
			<p class="yu-bor bbor">天津</p>
			<p class="yu-bor bbor">唐山</p>
			<p class="yu-bor bbor">太原</p>
			<p class="yu-bor bbor">通辽</p>
			<p class="yu-bor bbor">宁海（宁波）</p>
			<p class="yu-bor bbor">同里（吴江）</p>
			<p class="yu-bor bbor">台州</p>
			<p class="yu-bor bbor">桐庐</p>
			<p class="yu-bor bbor">桐乡</p>
			<p class="yu-bor bbor">铜陵</p>
			<p class="yu-bor bbor">泰安</p>
			<p class="yu-bor bbor">台山</p>
			<p class="yu-bor bbor">腾冲</p>
			<p class="yu-bor bbor">天水</p>
		</dd>
		<dt  id="w">W</dt>
		<dd>
			<p class="yu-bor bbor">五台山（忻州）</p>
			<p class="yu-bor bbor">无锡</p>
			<p class="yu-bor bbor">吴江（苏州）</p>
			<p class="yu-bor bbor">温州</p>
			<p class="yu-bor bbor">乌镇（桐乡）</p>
			<p class="yu-bor bbor">芜湖</p>
			<p class="yu-bor bbor">武夷山</p>
			<p class="yu-bor bbor">潍坊</p>
			<p class="yu-bor bbor">威海</p>
			<p class="yu-bor bbor">武汉</p>
			<p class="yu-bor bbor">武当山（十堰）</p>
			<p class="yu-bor bbor">梧州</p>
			<p class="yu-bor bbor">渭南华山</p>
			<p class="yu-bor bbor">乌鲁木齐</p>
		</dd>
		<dt  id="x">X</dt>
		<dd>
			<p class="yu-bor bbor">邢台</p>
			<p class="yu-bor bbor">兴城</p>
			<p class="yu-bor bbor">徐州</p>
			<p class="yu-bor bbor">象山（宁波）</p>
			<p class="yu-bor bbor">西塘（嘉善）</p>
			<p class="yu-bor bbor">厦门</p>
			<p class="yu-bor bbor">新乡</p>
			<p class="yu-bor bbor">许昌</p>
			<p class="yu-bor bbor">信阳</p>
			<p class="yu-bor bbor">咸宁</p>
			<p class="yu-bor bbor">襄阳</p>
			<p class="yu-bor bbor">湘潭</p>
			<p class="yu-bor bbor">西昌（凉山州）</p>
			<p class="yu-bor bbor">西江（千户苗寨）</p>
			<p class="yu-bor bbor">香格里拉（迪庆州）</p>
			<p class="yu-bor bbor">西双版纳</p>
			<p class="yu-bor bbor">西安</p>
			<p class="yu-bor bbor">咸阳</p>
			<p class="yu-bor bbor">西宁</p>
			<p class="yu-bor bbor">香港</p>
		</dd>
		<dt  id="y">Y</dt>
		<dd>
			<p class="yu-bor bbor">运城</p>
			<p class="yu-bor bbor">营口</p>
			<p class="yu-bor bbor">延吉</p>
			<p class="yu-bor bbor">扬州</p>
			<p class="yu-bor bbor">宜兴（无锡）</p>
			<p class="yu-bor bbor">盐城</p>
			<p class="yu-bor bbor">雁荡山（温州）</p>
			<p class="yu-bor bbor">余姚（宁波）</p>
			<p class="yu-bor bbor">宜春</p>
			<p class="yu-bor bbor">烟台</p>
			<p class="yu-bor bbor">宜昌</p>
			<p class="yu-bor bbor">岳阳</p>
			<p class="yu-bor bbor">阳江</p>
			<p class="yu-bor bbor">玉林</p>
			<p class="yu-bor bbor">阳朔（桂林）</p>
			<p class="yu-bor bbor">雅安</p>
			<p class="yu-bor bbor">宜宾</p>
			<p class="yu-bor bbor">延安</p>
			<p class="yu-bor bbor">榆林</p>
			<p class="yu-bor bbor">银川</p>
		</dd>
		<dt  id="z">Z</dt>
		<dd>
			<p class="yu-bor bbor">重庆</p>
			<p class="yu-bor bbor">张家口</p>
			<p class="yu-bor bbor">镇江</p>
			<p class="yu-bor bbor">张家港（苏州）</p>
			<p class="yu-bor bbor">溧阳天目湖（常州）</p>
			<p class="yu-bor bbor">周庄（昆山）</p>
			<p class="yu-bor bbor">衢州</p>
			<p class="yu-bor bbor">舟山</p>
			<p class="yu-bor bbor">漳州</p>
			<p class="yu-bor bbor">婺源</p>
			<p class="yu-bor bbor">淄博</p>
			<p class="yu-bor bbor">枣庄</p>
			<p class="yu-bor bbor">郑州</p>
			<p class="yu-bor bbor">株洲</p>
			<p class="yu-bor bbor">张家界</p>
			<p class="yu-bor bbor">珠海</p>
			<p class="yu-bor bbor">中山</p>
			<p class="yu-bor bbor">肇庆</p>
			<p class="yu-bor bbor">湛江</p>
			<p class="yu-bor bbor">自贡</p>
			<p class="yu-bor bbor">泸州</p>
			<p class="yu-bor bbor">阆中（南充）</p>
			<p class="yu-bor bbor">遵义</p>
			<p class="yu-bor bbor">镇远（黔东南州）</p>
			<p class="yu-bor bbor">泸沽湖</p>
			<p class="yu-bor bbor">张掖</p>
			<p class="yu-bor bbor">中卫</p>
		</dd>
	</dl>
</section>
<ul class="index">
	<li><a href="#a">A</a></li>
	<li><a href="#b">B</a></li>
	<li><a href="#c">C</a></li>
	<li><a href="#d">D</a></li>
	<li><a href="#e">E</a></li>
	<li><a href="#f">F</a></li>
	<li><a href="#g">G</a></li>
	<li><a href="#h">H</a></li>
	<%--<li><a href="#i">I</a></li>--%>
	<li><a href="#j">J</a></li>
	<li><a href="#k">K</a></li>
	<li><a href="#l">L</a></li>
	<li><a href="#m">M</a></li>
	<li><a href="#n">N</a></li>
	<%--<li><a href="#o">O</a></li>--%>
	<li><a href="#p">P</a></li>
	<li><a href="#q">Q</a></li>
	<li><a href="#r">R</a></li>
	<li><a href="#s">S</a></li>
	<li><a href="#t">T</a></li>
	<%--<li><a href="#u">U</a></li>--%>
	<%--<li><a href="#v">V</a></li>--%>
	<li><a href="#w">W</a></li>
	<li><a href="#x">X</a></li>
	<li><a href="#y">Y</a></li>
	<li><a href="#z">Z</a></li>
	
	
</ul>
<script>
    $(function () {
        $(".select-item>p").on("click", function () {
            $(this).addClass("cur").siblings().removeClass("cur");
        })
    })
</script>
</body>
</html>