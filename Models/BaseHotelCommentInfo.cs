using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using hotel3g.Models.Home;

namespace hotel3g.Models
{
    /// <summary>
    /// 酒店评论基础统计信息
    /// </summary>
    public class BaseHotelCommentInfo
    {
        public int HotelID { get; set; }
        /// <summary>
        /// 综合卫生评分
        /// </summary>
        public string HSSAvg { get; set; }
        /// <summary>
        /// 综合设施评分
        /// </summary>
        public string FSSAvg { get; set; }
        /// <summary>
        /// 综合网络评分
        /// </summary>
        public string NSSAvg { get; set; }
        /// <summary>
        ///  综合服务评分
        /// </summary>
        public string ASSAvg { get; set; }
        /// <summary>
        /// 综合评分
        /// </summary>
        public string AllAvg { get; set; }
        /// <summary>
        /// 评论总量
        /// </summary>
        public int CommentAllCount { get; set; }
        /// <summary>
        /// 有图评论数
        /// </summary>
        public int HasPicCount { get; set; }
        /// <summary>
        /// 全部评论数据
        /// </summary>
        public List<Comment> Comments { get; set; }
    }
}