<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

	    <section class="mask alert">
		    <div class="inner yu-w480r">
			    <div class="yu-bgw">
				    <p class="yu-lrpad40r yu-tbpad50r yu-textc yu-bor bbor yu-f30r" id="tishi_msg">请您输入必填信息</p>
				    <div class="yu-h80r yu-l80r yu-textc yu-c40 yu-f36r yu-grid">
					    <p class="yu-overflow mask-close">知道了</p>
					
				    </div>
			    </div>
		    </div>
	    </section>
        <script>
            $(".mask-close,.mask").click(function () {
                $(".mask").fadeOut();
            })
        </script>