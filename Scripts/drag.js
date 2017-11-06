$(function(){
	function drag(obj,parentNode){
    var obj = document.getElementById(obj);
    
    
    if(arguments.length == 1){
        var parentNode = window.self;  
        var pWidth = parentNode.innerWidth,pHeight = parentNode.innerHeight;   
    }else{
        var parentNode = document.getElementById(parentNode);
        var pWidth = parentNode.clientWidth,pHeight = parentNode.clientHeight;
    }
    obj.addEventListener('touchstart',function(event){
        //当只有一个手指时              .
//      if(event.touches.length == 1){
//          //禁止浏览器默认事
//          event.preventDefault();
//      };
        var touch = event.targetTouches[0];
        var disX = touch.clientX - obj.offsetLeft,disY = touch.clientY - obj.offsetTop;
        var oWidth = obj.offsetWidth,oHeight = obj.offsetHeight;
 
        obj.addEventListener('touchmove',function(event){
        	 //当只有一个手指时              .
	        if(event.touches.length == 1){
	            //禁止浏览器默认事
	            event.preventDefault();
	        };
            var touch = event.targetTouches[0];
//          obj.style.left = touch.clientX - disX  + 'px';
            obj.style.top = touch.clientY - disY + 'px';
            //左侧
            if(obj.offsetLeft <=0){
                obj.style.left = 0;
            };
            //右侧
            if(obj.offsetLeft >= pWidth -oWidth){
                obj.style.left =  pWidth - oWidth + 'px';  
             };
            //上面
            if(obj.offsetTop <= 0){
                obj.style.top = 0; 
            };
            //下面
            if(obj.offsetTop >= pHeight - oHeight){
                obj.style.top =  pHeight - oHeight + 'px'; 
            };                 
        });
        obj.addEventListener('touchend',function(event){
//          obj.removeEventListener('touchmove');
//          obj.removeEventListener('touchend');
        })
        
        
    });
}

drag("drag")

	
})
	
