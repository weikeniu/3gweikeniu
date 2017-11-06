<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%
    if (Html.ViewData["jq"] == null)
    {%>
<script type="text/javascript" src="../../Scripts/jquery-1.8.0.min.js"></script>
<%}
%>
<script type="text/javascript">
    jQuery(function () {
        var isSupportTouch = "ontouchend" in document ? true : false;
        if (isSupportTouch) {
            jQuery(document.body).on('touchstart', function (e) {
                var that = jQuery(e.target), index = '';
                //console.log(that.attr('data-cu'));
                if (!that.attr('data-cu')) {
                    jQuery('#ft_leader').siblings().hide();
                } else {
                    index = that.attr('data-cu');
                    var tmp = jQuery('#' + index);
                    if (tmp) {
                        tmp.siblings('div').hide();
                        if (tmp.is(':visible')) {
                            tmp.hide();
                        } else {
                            tmp.show();
                        }
                    }
                }
            });
        } else {
            jQuery('#ft_leader').on("click", 'a[class*="ft"]', function () {
                var that = jQuery(this);
                var index = that.attr("data-cu");
                var tmp = jQuery('#' + index);
                if (tmp) {
                    tmp.siblings('div').hide();
                    if (tmp.is(':visible')) {
                        tmp.hide();
                    } else {
                        tmp.show();
                    }
                }
            });
        }
    });
</script>
