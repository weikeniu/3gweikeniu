using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace hotel3g.Common
{
    public class AuthorityResponse
    {
        /// <summary>
        /// 是否启用
        /// </summary>
        public int endabled { get; set; }
        /// <summary>
        /// 审核状态
        /// </summary>
        public int examine { get; set; }
        /// <summary>
        /// 预付审核
        /// </summary>
        public int pay_examine { get; set; }
        /// <summary>
        /// 分店
        /// </summary>
        public int branch { get; set; }
        /// <summary>
        /// 餐饮
        /// </summary>
        public int canyin { get; set; }
        /// <summary>
        /// 超市
        /// </summary>
        public int supermarketrket { get; set; }
        /// <summary>
        /// 订房会员专享
        /// </summary>
        public int dingfang_MemberOnly { get; set; }
        /// <summary>
        /// 会议厅
        /// </summary>
        public int meeting { get; set; }
        /// <summary>
        /// 是否开启新版本
        /// </summary>
        public int edition { get; set; }
        /// <summary>
        /// 前台风格
        /// </summary>
        public int style { get; set; }
        /// <summary>
        /// 客房预订石展示
        /// </summary>
        public int kefang { get; set; }
        /// <summary>
        /// 旅行社版本
        /// </summary>
        public int TravelEdition { get; set; }
        /// <summary>
        /// 评论
        /// </summary>
        public int comment { get; set; }
        /// <summary>
        /// 自定义会员展示
        /// </summary>
        public int membershow { get; set; }
        /// <summary>
        /// 展示会员价
        /// </summary>
        public int showmemberprice { get; set; }



    }

    /// <summary>
    /// 微可牛功能模块信息
    /// </summary>
    public class ModuleAuthorityResponse
    {
        /// <summary>
        /// --微信号
        /// </summary>
        public string weixinid { get; set; }
        /// <summary>
        /// -账户审核
        /// </summary>
        public int examine { get; set; }
        /// <summary>
        /// 预付审核
        /// </summary>
        public int prepay { get; set; }
        /// <summary>
        /// 连锁模块
        /// </summary>
        public int module_chain { get; set; }
        /// <summary>
        /// 餐饮模块
        /// </summary>
        public int module_meals { get; set; }
        /// <summary>
        /// 超市模块
        /// </summary>
        public int module_supermarket { get; set; }
        /// <summary>
        /// 系统版本（新版 旧版）
        /// </summary>
        public int edition { get; set; }
        /// <summary>
        /// 会议厅模块
        /// </summary>
        public int module_meeting { get; set; }
        /// <summary>
        /// 评论权限
        /// </summary>
        public int comment { get; set; }

        /// <summary>
        /// 自定义会员模块
        /// </summary>
        public int module_member { get; set; }
        /// <summary>
        /// 基础会员权限
        /// </summary>
        public int module_memberbasics { get; set; }

        /// <summary>
        /// 订房模块
        /// </summary>
        public int module_room { get; set; }
        /// <summary>
        /// 旅行社模块
        /// </summary>
        public int module_lxs { get; set; }
        /// <summary>
        /// 智能模块
        /// </summary>
        public int module_zhineng { get; set; }
        /// <summary>
        /// 展示会员价
        /// </summary>
        public int membership_price { get; set; }
        /// <summary>
        /// 订房需会员
        /// </summary>
        public int membership_room { get; set; }
        /// <summary>
        /// 免费wifi
        /// </summary>
        public int module_freewifi { get; set; }
        /// <summary>
        /// 分销模块
        /// </summary>
        public int module_fenxiao { get; set; }
        /// <summary>
        /// 拼团
        /// </summary>
        public int module_pintuan { get; set; }

    }
}