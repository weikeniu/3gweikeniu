$(function(){
	//mask消除默认事件
		$(".mask").on("touchmove",function(e){
			event.preventDefault();
		})
	//快速导航
//	$(".fix-btn").click(function(e){
//		e.stopPropagation();
//		$(this).toggleClass("cur").children(".show-hide").toggleClass("cur");
//		$(".fix-right-slide").toggle();
//	})
})