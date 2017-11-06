<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<style>
    #select-item p
    {
        display: none;
    }
    .letter dd p
    {
        display: none;
    }
    .letter dt
    {
        display: none;
    }
</style>
<!--目的地-->
<article class="local-page">
	<section class="yu-h80r yu-bgw yu-bor bbor">
		<div class="back yu-h80r yu-grid yu-alignc yu-lrpad20r">
			<a class="yu-back-arr" href="javascript:HideLocat();"></a>
			<div class="yu-overflow yu-f26r yu-c99" onclick="HideLocat()">关闭</div>
			<a class="reset yu-f26r yu-blue" href="javascript:ClearAll();">重置</a>
		</div>
	</section>
	<section class="yu-lpad20r yu-tpad40r">
	<dl class="yu-bmar40r">
		<dt class="yu-c77 yu-f26r yu-bmar30r">我的位置</dt>
		<dd class="yu-grid select-item yu-flex-w-w">
			<p class="sp"><input type="hidden" class="sp_hid" /><label class="sp_lab"></label></p>
		</dd>
	</dl>
	<dl>
		<dt class="yu-c77 yu-f26r yu-bmar30r">热门</dt>
		<dd class="yu-grid select-item yu-flex-w-w select-item" id="select-item-hot">
            <p style="display:block;"><label class="sp_lab">不限</label></p>
			<p><input type="hidden" class="sp_hid" value="100.229628399,26.8753510895" /><label class="sp_lab">丽江</label></p>
			<p><input type="hidden" class="sp_hid" value="116.395645038,39.9299857781" /><label class="sp_lab">北京</label></p>
			<p><input type="hidden" class="sp_hid" value="121.487899486,31.24916171" /><label class="sp_lab">上海</label></p>
			<p><input type="hidden" class="sp_hid" value="120.219375416,30.2592444615" /><label class="sp_lab">杭州</label></p>
			<p><input type="hidden" class="sp_hid" value="111.590952812,21.9464822541" /><label class="sp_lab">高雄</label></p>
			<p><input type="hidden" class="sp_hid" value="114.130474436,22.3748329286" /><label class="sp_lab">台北</label></p>
			<p><input type="hidden" class="sp_hid" value="114.183870524,22.2721034276" /><label class="sp_lab">香港</label></p>
			<p><input type="hidden" class="sp_hid" value="113.566432335,22.1950041592" /><label class="sp_lab">澳门</label></p>
			<p><input type="hidden" class="sp_hid" value="118.103886046,24.4892306125" /><label class="sp_lab">厦门</label></p>
			<p><input type="hidden" class="sp_hid" value="114.316200103,30.5810841269" /><label class="sp_lab">武汉</label></p>
			<p><input type="hidden" class="sp_hid" value="114.41065808,23.1135398524" /><label class="sp_lab">惠州</label></p>
			<p><input type="hidden" class="sp_hid" value="113.307649675,23.1200491021" /><label class="sp_lab">广州</label></p>
			<p><input type="hidden" class="sp_hid" value="114.025973657,22.5460535462" /><label class="sp_lab">深圳</label></p>
			<p><input type="hidden" class="sp_hid" value="113.562447026,22.2569146461" /><label class="sp_lab">珠海</label></p>
			<p><input type="hidden" class="sp_hid" value="113.134025635,23.0350948405" /><label class="sp_lab">佛山</label></p>
			<p><input type="hidden" class="sp_hid" value="110.260920147,25.262901246" /><label class="sp_lab">桂林</label></p>
		</dd>
	</dl>
</section>
<section class="letter">
	<dl>
		<dt id="a">A</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="123.007763329,41.1187436822" /><label class="sp_lab">鞍山</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="117.058738772,30.5378978174" /><label class="sp_lab">安庆</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="105.928269966,26.2285945777" /><label class="sp_lab">安顺</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="113.566432335,22.1950041592" /><label class="sp_lab">澳门</label></p>
		</dd>
		<dt  id="b">B</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="116.395645038,39.9299857781" /><label class="sp_lab">北京</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="115.494810169,38.886564548" /><label class="sp_lab">保定</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="109.846238532,40.6471194257" /><label class="sp_lab">包头</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="123.77806237,41.3258376266" /><label class="sp_lab">本溪</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="117.357079866,32.9294989067" /><label class="sp_lab">蚌埠</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="117.968292415,37.4053139418" /><label class="sp_lab">滨州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="109.122627919,21.472718235" /><label class="sp_lab">北海</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="106.631821404,23.9015123679" /><label class="sp_lab">百色</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="107.170645452,34.3640808097" /><label class="sp_lab">宝鸡</label></p>
		</dd>
		<dt  id="c">C</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="117.933822456,40.9925210525" /><label class="sp_lab">承德</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="116.863806476,38.2976153503" /><label class="sp_lab">沧州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="113.120292086,36.2016643857" /><label class="sp_lab">长治</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="118.930761192,42.2971123203" /><label class="sp_lab">赤峰</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="125.313642427,43.8983376071" /><label class="sp_lab">长春</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="119.981861013,31.7713967447" /><label class="sp_lab">常州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="112.979352788,28.2134782309" /><label class="sp_lab">长沙</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="113.037704468,25.7822639757" /><label class="sp_lab">郴州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="116.630075991,23.6618116765" /><label class="sp_lab">潮州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="104.067923463,30.6799428454" /><label class="sp_lab">成都</label></p>
		</dd>
		<dt  id="d">D</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="113.290508673,40.1137444997" /><label class="sp_lab">大同</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="121.593477781,38.9487099383" /><label class="sp_lab">大连</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="124.338543115,40.1290228266" /><label class="sp_lab">丹东</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="125.02183973,46.59670902" /><label class="sp_lab">大庆</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="118.583926333,37.4871211553" /><label class="sp_lab">东营</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="116.328161364,37.4608259263" /><label class="sp_lab">德州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="113.763433991,23.0430238154" /><label class="sp_lab">东莞</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="104.402397818,31.1311396527" /><label class="sp_lab">德阳</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="107.494973447,31.2141988589" /><label class="sp_lab">达州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="100.223674789,25.5968996394" /><label class="sp_lab">大理</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="94.660931,40.1477" /><label class="sp_lab">敦煌</label></p>
		</dd>
		<dt  id="e">E</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="109.993706251,39.8164895606" /><label class="sp_lab">鄂尔多斯</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="109.491923304,30.2858883166" /><label class="sp_lab">恩施</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="112.310038,22.189989" /><label class="sp_lab">恩平</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="103.462088,29.578599" /><label class="sp_lab">峨眉山</label></p>
		</dd>
		<dt  id="f">F</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="123.929819767,41.8773038296" /><label class="sp_lab">抚顺</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="115.820932259,32.9012113306" /><label class="sp_lab">阜阳</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="119.330221107,26.0471254966" /><label class="sp_lab">福州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="113.134025635,23.0350948405" /><label class="sp_lab">佛山</label></p>
		</dd>
		<dt  id="g">G</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="114.935909079,25.8452955363" /><label class="sp_lab">赣州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="113.307649675,23.1200491021" /><label class="sp_lab">广州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="110.260920147,25.262901246" /><label class="sp_lab">桂林</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="105.81968694,32.4410401584" /><label class="sp_lab">广元</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="106.709177096,26.6299067414" /><label class="sp_lab">贵阳</label></p>
		</dd>
		<dt  id="h">H</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="115.686228653,37.7469290459" /><label class="sp_lab">衡水</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="114.482693932,36.6093079285" /><label class="sp_lab">邯郸</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="111.66035052,40.8283188731" /><label class="sp_lab">呼和浩特</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="120.860757645,40.7430298813" /><label class="sp_lab">葫芦岛</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="126.657716855,45.7732246332" /><label class="sp_lab">哈尔滨</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="119.030186365,33.6065127393" /><label class="sp_lab">淮安</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="120.219375416,30.2592444615" /><label class="sp_lab">杭州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="120.684509,30.520345" /><label class="sp_lab">海宁</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="120.137243163,30.8779251557" /><label class="sp_lab">湖州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="120.786976,30.750248" /><label class="sp_lab">横店</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="117.282699092,31.8669422607" /><label class="sp_lab">合肥</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="118.293569632,29.7344348562" /><label class="sp_lab">黄山</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="117.018638863,32.6428118237" /><label class="sp_lab">淮南</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="112.583818811,26.8981644154" /><label class="sp_lab">衡阳</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="114.41065808,23.1135398524" /><label class="sp_lab">惠州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="114.713721476,23.7572508505" /><label class="sp_lab">河源</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="110.330801848,20.022071277" /><label class="sp_lab">海口</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="107.045477629,33.0815689782" /><label class="sp_lab">汉中</label></p>
		</dd>
		<dt  id="j">J</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="112.7385144,37.6933615268" /><label class="sp_lab">晋中</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="112.867332758,35.4998344672" /><label class="sp_lab">晋城</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="121.147748738,41.1308788759" /><label class="sp_lab">锦州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="126.564543989,43.8719883344" /><label class="sp_lab">吉林</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="119.652575704,29.1028991054" /><label class="sp_lab">金华</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="120.760427699,30.7739922396" /><label class="sp_lab">嘉兴</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="118.554979,24.786457" /><label class="sp_lab">晋江</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="115.999848022,29.7196395261" /><label class="sp_lab">九江</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="117.186522625,29.3035627684" /><label class="sp_lab">景德镇</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="117.024967066,36.6827847272" /><label class="sp_lab">济南</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="116.600797625,35.4021216643" /><label class="sp_lab">济宁</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="113.211835885,35.234607555" /><label class="sp_lab">焦作</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="112.241865807,30.332590523" /><label class="sp_lab">荆州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="116.379500855,23.5479994669" /><label class="sp_lab">揭阳</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="113.078125341,22.5751167835" /><label class="sp_lab">江门</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="104.242261,33.267218" /><label class="sp_lab">九寨沟</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="98.2816345853,39.8023973267" /><label class="sp_lab">嘉峪关</label></p>
		</dd>
		<dt  id="k">K</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="114.351642118,34.8018541758" /><label class="sp_lab">开封</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="112.700376,22.382746" /><label class="sp_lab">开平</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="102.714601139,25.0491531005" /><label class="sp_lab">昆明</label></p>
		</dd>
		<dt  id="l">L</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="116.703602223,39.5186106251" /><label class="sp_lab">廊坊</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="111.538787596,36.0997454436" /><label class="sp_lab">临汾</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="119.173872217,34.601548967" /><label class="sp_lab">连云港</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="119.929575843,28.4562995521" /><label class="sp_lab">丽水</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="116.505252683,31.7555583552" /><label class="sp_lab">六安</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="117.017996739,25.0786854335" /><label class="sp_lab">龙岩</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="118.340768237,35.0724090744" /><label class="sp_lab">临沂</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="115.986869139,36.4558285147" /><label class="sp_lab">聊城</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="112.447524769,34.6573678177" /><label class="sp_lab">洛阳</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="109.42240181,24.3290533525" /><label class="sp_lab">柳州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="103.760824239,29.6009576111" /><label class="sp_lab">乐山</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="100.229628399,26.8753510895" /><label class="sp_lab">丽江</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="91.111890896,29.6625570621" /><label class="sp_lab">拉萨</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="103.823305441,36.064225525" /><label class="sp_lab">兰州</label></p>
		</dd>
		<dt  id="m">M</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="129.608035396,44.5885211528" /><label class="sp_lab">牡丹江</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="118.515881847,31.6885281589" /><label class="sp_lab">马鞍山</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="110.931245331,21.6682257188" /><label class="sp_lab">茂名</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="116.126403098,24.304570606" /><label class="sp_lab">梅州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="104.705518975,31.5047012581" /><label class="sp_lab">绵阳</label></p>
		</dd>
		<dt  id="n">N</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="118.778074408,32.0572355018" /><label class="sp_lab">南京</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="120.873800951,32.0146645408" /><label class="sp_lab">南通</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="121.579005973,29.8852589659" /><label class="sp_lab">宁波</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="115.893527546,28.6895780001" /><label class="sp_lab">南昌</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="112.542841901,33.0114195691" /><label class="sp_lab">南阳</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="108.297233556,22.8064929356" /><label class="sp_lab">南宁</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="106.105553984,30.8009651682" /><label class="sp_lab">南充</label></p>
		</dd>
		<dt  id="p">P</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="122.07322781,41.141248023" /><label class="sp_lab">盘锦</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="119.077730964,25.4484501367" /><label class="sp_lab">莆田</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="101.722423152,26.5875712571" /><label class="sp_lab">攀枝花</label></p>
		</dd>
		<dt  id="q">Q</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="119.604367616,39.9454615659" /><label class="sp_lab">秦皇岛</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="123.987288942,47.3476998134" /><label class="sp_lab">齐齐哈尔</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="118.600362343,24.901652384" /><label class="sp_lab">泉州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="120.384428184,36.1052149013" /><label class="sp_lab">青岛</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="113.040773349,23.6984685504" /><label class="sp_lab">清远</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="108.638798056,21.9733504653" /><label class="sp_lab">钦州</label></p>
		</dd>
		<dt  id="r">R</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="119.507179943,35.4202251931" /><label class="sp_lab">日照</label></p>
		</dd>
		<dt  id="s">S</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="121.487899486,31.24916171" /><label class="sp_lab">上海</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="114.522081844,38.0489583146" /><label class="sp_lab">石家庄</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="123.432790922,41.8086447835" /><label class="sp_lab">沈阳</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="120.619907115,31.317987368" /><label class="sp_lab">苏州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="118.296893379,33.9520497337" /><label class="sp_lab">宿迁</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="120.592467386,30.0023645805" /><label class="sp_lab">绍兴</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="117.955463877,28.4576225539" /><label class="sp_lab">上饶市</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="115.641885688,34.4385886402" /><label class="sp_lab">商丘</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="110.801228917,32.6369943395" /><label class="sp_lab">十堰</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="116.728650288,23.3839084533" /><label class="sp_lab">汕头</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="114.025973657,22.5460535462" /><label class="sp_lab">深圳</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="113.594461107,24.8029603119" /><label class="sp_lab">韶关</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="115.372924289,22.7787305002" /><label class="sp_lab">汕尾</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="109.522771281,18.2577759149" /><label class="sp_lab">三亚</label></p>
		</dd>
		<dt  id="t">T</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="117.210813092,39.1439299033" /><label class="sp_lab">天津</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="118.183450598,39.6505309225" /><label class="sp_lab">唐山</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="112.550863589,37.890277054" /><label class="sp_lab">太原</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="122.260363263,43.633756073" /><label class="sp_lab">通辽</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="121.440612936,28.6682832857" /><label class="sp_lab">台州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="119.694401,29.798873" /><label class="sp_lab">桐庐</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="120.568381,30.636551" /><label class="sp_lab">桐乡</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="117.819428729,30.9409296947" /><label class="sp_lab">铜陵</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="117.089414917,36.1880777589" /><label class="sp_lab">泰安</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="112.80166,22.258182" /><label class="sp_lab">台山</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="105.736931623,34.5843194189" /><label class="sp_lab">天水</label></p>
		</dd>
		<dt  id="w">W</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="120.305455901,31.5700374519" /><label class="sp_lab">无锡</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="120.690634734,28.002837594" /><label class="sp_lab">温州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="118.384108423,31.3660197875" /><label class="sp_lab">芜湖</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="118.045664,27.758912" /><label class="sp_lab">武夷山</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="119.142633823,36.7161148731" /><label class="sp_lab">潍坊</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="122.093958366,37.5287870813" /><label class="sp_lab">威海</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="114.316200103,30.5810841269" /><label class="sp_lab">武汉</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="111.30547195,23.4853946367" /><label class="sp_lab">梧州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="109.483932697,34.5023579758" /><label class="sp_lab">渭南</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="87.5649877411,43.8403803472" /><label class="sp_lab">乌鲁木齐</label></p>
		</dd>
		<dt  id="x">X</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="114.520486813,37.0695311969" /><label class="sp_lab">邢台</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="117.188106623,34.2715534311" /><label class="sp_lab">徐州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="118.103886046,24.4892306125" /><label class="sp_lab">厦门</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="113.912690161,35.3072575577" /><label class="sp_lab">新乡</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="113.83531246,34.0267395887" /><label class="sp_lab">许昌</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="114.085490993,32.1285823075" /><label class="sp_lab">信阳</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="114.300060592,29.8806567577" /><label class="sp_lab">咸宁</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="112.250092848,32.2291685915" /><label class="sp_lab">襄阳</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="112.935555633,27.835095053" /><label class="sp_lab">湘潭</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="100.803038275,22.0094330022" /><label class="sp_lab">西双版纳</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="108.953098279,34.2777998978" /><label class="sp_lab">西安</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="108.707509278,34.345372996" /><label class="sp_lab">咸阳</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="101.76792099,36.640738612" /><label class="sp_lab">西宁</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="114.183870524,22.2721034276" /><label class="sp_lab">香港</label></p>
		</dd>
		<dt  id="y">Y</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="111.006853653,35.0388594798" /><label class="sp_lab">运城</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="122.233391371,40.6686510665" /><label class="sp_lab">营口</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="119.427777551,32.4085052546" /><label class="sp_lab">扬州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="120.148871818,33.3798618771" /><label class="sp_lab">盐城</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="114.400038672,27.8111298958" /><label class="sp_lab">宜春</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="121.30955503,37.5365615629" /><label class="sp_lab">烟台</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="111.310981092,30.732757818" /><label class="sp_lab">宜昌</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="113.146195519,29.3780070755" /><label class="sp_lab">岳阳</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="111.977009756,21.8715173045" /><label class="sp_lab">阳江</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="110.151676316,22.6439736084" /><label class="sp_lab">玉林</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="103.009356466,29.9997163371" /><label class="sp_lab">雅安</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="104.633019062,28.7696747963" /><label class="sp_lab">宜宾</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="109.500509757,36.6033203523" /><label class="sp_lab">延安</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="109.745925744,38.2794392401" /><label class="sp_lab">榆林</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="106.206478608,38.5026210119" /><label class="sp_lab">银川</label></p>
		</dd>
		<dt  id="z">Z</dt>
		<dd>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="106.530635013,29.5446061089" /><label class="sp_lab">重庆</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="114.89378153,40.8111884911" /><label class="sp_lab">张家口</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="119.455835405,32.2044094436" /><label class="sp_lab">镇江</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="118.875841652,28.9569104475" /><label class="sp_lab">衢州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="122.169872098,30.0360103026" /><label class="sp_lab">舟山</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="117.676204679,24.5170647798" /><label class="sp_lab">漳州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="117.864924,29.253333" /><label class="sp_lab">婺源</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="118.059134278,36.8046848542" /><label class="sp_lab">淄博</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="117.279305383,34.8078830784" /><label class="sp_lab">枣庄</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="113.64964385,34.7566100641" /><label class="sp_lab">郑州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="113.131695341,27.8274329277" /><label class="sp_lab">株洲</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="110.481620157,29.1248893532" /><label class="sp_lab">张家界</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="113.562447026,22.2569146461" /><label class="sp_lab">珠海</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="113.422060021,22.5451775145" /><label class="sp_lab">中山</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="112.47965337,23.0786632829" /><label class="sp_lab">肇庆</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="110.365067263,21.2574631038" /><label class="sp_lab">湛江</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="104.776071339,29.3591568895" /><label class="sp_lab">自贡</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="105.443970289,28.8959298039" /><label class="sp_lab">泸州</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="106.931260316,27.6999613771" /><label class="sp_lab">遵义</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="100.913867,27.72254" /><label class="sp_lab">泸沽湖</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="100.459891869,38.939320297" /><label class="sp_lab">张掖</label></p>
			<p class="yu-bor bbor"><input type="hidden" class="sp_hid" value="105.196754199,37.5211241916" /><label class="sp_lab">中卫</label></p>
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
</article>
<!--目的地end-->
<script>

    //目的地
    $(".local-btn").click(function () {
        $(".base-page").hide();
        $(".local-page").show();
    })
    $(".select-item>p").on("click", function () {
        ClearCur();
        $(".nav-btn1").html($(this).find(".sp_lab").html());
        $(".base-page").show();
        $(".local-page").hide();
        //刷新数据
        if ($(this).find(".sp_lab").html() == "不限") {
            ClearAll();
        } else {
            if ($(this).find(".sp_lab").html() == "全国") {
                ChangeLocat($(this).find(".sp_hid").val(), "");
            } else {
                ChangeLocat($(this).find(".sp_hid").val(), $(this).find(".sp_lab").html());
            }
        }
        $(this).addClass("cur").siblings().removeClass("cur");
    })
    $(".letter dd>p").on("click", function () {
        ClearCur();
        $(this).addClass("cur").siblings().removeClass("cur");
        $(".nav-btn1").html($(this).find(".sp_lab").html());
        $(".base-page").show();
        $(".local-page").hide();
        //刷新数据
        ChangeLocat($(this).find(".sp_hid").val(), $(this).find(".sp_lab").html());


    })

    function HideLocat() {
        $(".local-page").hide();
        $(".base-page").show();
    }
    function ClearAll() {
        ClearCur();
        HideLocat();
        //刷新数据
        ChangeLocat("", "");
        $(".nav-btn1").html("城市");
    }
    function HideAll() {
        $("#select-item-hot>p").each(function () {

            if ($(this).find(".sp_lab").html() != "不限") {
                $(this).hide();
            }
        });
        $(".letter dd>p").each(function () {
            $(this).parent().prev().hide();
            $(this).hide();
        });
    }

    function ClearCur() {
        $(".select-item>p").each(function () {
            if ($(this).hasClass("cur")) {
                $(this).removeClass("cur");
            }
        });
        $(".letter dd>p").each(function () {
            if ($(this).hasClass("cur")) {
                $(this).removeClass("cur");
            }
        });
    }

    function ShowLocal(arr1, arr2) {
        $("#select-item-hot>p").each(function () {
            if (arr1.indexOf($(this).find(".sp_lab").html()) > -1) {
                $(this).show();
            }
        });
        $(".letter dd>p").each(function () {
            if (arr1.indexOf($(this).find(".sp_lab").html()) > -1) {
                $(this).parent().prev().show();
                $(this).show();
            }
        });
        $("#select-item-hot>p").each(function () {
            if (arr2.indexOf($(this).find(".sp_lab").html()) > -1) {
                $(this).show();
            }
        });
        $(".letter dd>p").each(function () {
            if (arr2.indexOf($(this).find(".sp_lab").html()) > -1) {
                $(this).parent().prev().show();
                $(this).show();
            }
        });
    }
</script>
