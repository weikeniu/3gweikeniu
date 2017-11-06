using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using hotel3g.Models.DAL;
using System.Data;

namespace hotel3g.Models.Home
{
    /// <summary>
    /// 酒店评价实体、BLL
    /// </summary>
    public class Comment
    {
        #region DAL
        CommentDAL commentDAL = new CommentDAL();
        #endregion

        #region 字段
        public int ID { get; set; }
        /// <summary>
        /// 酒店ID
        /// </summary>
        public int HotelID { get; set; }
        /// <summary>
        /// 订单ID
        /// </summary>
        public int OrderID { get; set; }
        /// <summary>
        /// 评价人微信ID
        /// </summary>
        public string UserWeixinID { get; set; }
        /// <summary>
        /// 酒店微信ID
        /// </summary>
        public string HotelWeixinID { get; set; }
        /// <summary>
        /// 评价内容
        /// </summary>
        public string Content { get; set; }
        /// <summary>
        /// 评价图片链接
        /// </summary>
        public string Imgs { get; set; }
        /// <summary>
        /// 卫生服务评分(5分)
        /// </summary>
        public int HealthServiceScore { get; set; }
        /// <summary>
        /// 设施服务评分（5分）
        /// </summary>
        public int FacilityServiceScore { get; set; }
        /// <summary>
        /// 网络服务评分（5分）
        /// </summary>
        public int NetworkServiceScore { get; set; }
        /// <summary>
        /// 服务态度评分(5分)
        /// </summary>
        public int AttitudeServiceScore { get; set; }
        /// <summary>
        /// 综合评分
        /// </summary>
        public decimal AvgScore { get; set; }
        /// <summary>
        /// 房型
        /// </summary>
        public string RoomType { get; set; }
        /// <summary>
        /// 是否展示
        /// </summary>
        public bool IsShow { get; set; }
        /// <summary>
        /// 评价时间
        /// </summary>
        public DateTime CreateTime { get; set; }

        //以下为DTO附加字段
        /// <summary>
        /// 评价图片链接数组
        /// </summary>
        public string[] ImgArr { get; set; }
        /// <summary>
        /// 评论时间显示格式
        /// </summary>
        public string CommentTimeText { get; set; }
        /// <summary>
        /// 用户微信昵称
        /// </summary>
        public string UserWxNickName { get; set; }
        /// <summary>
        /// 用户微信头像
        /// </summary>
        public string UserWxAvatar { get; set; }
        /// <summary>
        /// 0未回复消息1已回复
        /// </summary>
        public int IsReply { get; set; }
        /// <summary>
        /// 消息类型：0客户消息1酒店回复消息
        /// </summary>
        public int MsgType { get; set; }
        /// <summary>
        /// 回复的消息ID
        /// </summary>
        public int MsgID { get; set; }
        #endregion

        #region 方法

        /// <summary>
        /// 根据酒店ID获取该酒店所有可展示的评价信息
        /// </summary>
        /// <param name="hotelID">酒店ID</param>
        /// <returns></returns>
        public List<Comment> GetListByHotelID(int hotelID)
        {
            var comments = new List<Comment>();
            var dt = commentDAL.GetListByHotelID(hotelID);
            foreach (DataRow r in dt.Rows)
            {
                var m = new Comment();
                m.ID = (int)r["ID"];
                m.HotelID = (int)r["HotelID"];
                m.OrderID = (int)r["OrderID"];
                m.UserWeixinID = (string)r["UserWeixinID"];
                m.HotelWeixinID = (string)r["HotelWeixinID"];
                m.Content = (string)r["Content"];
                m.HealthServiceScore = (int)r["HealthServiceScore"];
                m.FacilityServiceScore = (int)r["FacilityServiceScore"];
                m.NetworkServiceScore = (int)r["NetworkServiceScore"];
                m.AttitudeServiceScore = (int)r["AttitudeServiceScore"];
                m.AvgScore = (decimal)r["AvgScore"];
                m.RoomType = r["RoomType"] == DBNull.Value ? "" : (string)r["RoomType"];
                m.CreateTime = (DateTime)r["CreateTime"];
                m.Imgs = r["Imgs"] == DBNull.Value ? "" : (string)r["Imgs"];
                m.ImgArr = !string.IsNullOrEmpty(m.Imgs) ? m.Imgs.Split(new char[] { '|' }, StringSplitOptions.RemoveEmptyEntries) : new string[0];
                m.CommentTimeText = m.CreateTime.ToString("yyyy-MM-dd HH:ss");
                m.UserWxNickName = r["NickName"] == DBNull.Value ? "" : (string)r["NickName"];
                m.UserWxNickName = string.IsNullOrEmpty(m.UserWxNickName) ? "匿名用户" : m.UserWxNickName;
                m.UserWxAvatar = r["Phone"] == DBNull.Value ? "" : (string)r["Phone"];
                m.IsReply = Convert.ToInt32(r["IsReply"]);
                m.MsgID = Convert.ToInt32(r["MsgID"]);
                m.MsgType = Convert.ToInt32(r["MsgType"]);
                comments.Add(m);
            }
            return comments;
        }
        /// <summary>
        /// 评价
        /// </summary>
        /// <param name="comment"></param>
        /// <returns></returns>
        public bool CommentHotel(Comment comment) 
        {
            var flag = commentDAL.InsertModel(comment);
            if (flag) 
            {
                var dic = GetHotelsScoreAvg(new List<int>() { comment.HotelID });
                commentDAL.UpdateHotelAvgScore(comment.HotelID, dic[comment.HotelID]);
            }
            return flag;
        }
        /// <summary>
        /// 获取酒店评论基础信息
        /// </summary>
        /// <param name="hotelID"></param>
        /// <returns></returns>
        public BaseHotelCommentInfo GetBaseInfo(int hotelID) 
        {
            var comments = GetListByHotelID(hotelID);
            int allCount = comments.Count();//全部数量
            int hasPicCount = comments.Where(c => !string.IsNullOrWhiteSpace(c.Imgs)).Count();//有图片评价数量
            double hssAvg = allCount <= 0 ? 5.0 : Math.Round(comments.Sum(c => c.HealthServiceScore) * 1.0 / allCount, 1);// 综合卫生评分
            double fssAvg = allCount <= 0 ? 5.0 : Math.Round(comments.Sum(c => c.FacilityServiceScore) * 1.0 / allCount, 1);// 综合设施评分
            double nssAvg = allCount <= 0 ? 5.0 : Math.Round(comments.Sum(c => c.NetworkServiceScore) * 1.0 / allCount, 1);// 综合网络评分
            double assAvg = allCount <= 0 ? 5.0 : Math.Round(comments.Sum(c => c.AttitudeServiceScore) * 1.0 / allCount, 1);// 综合服务评分
            BaseHotelCommentInfo baseInfo = new BaseHotelCommentInfo();
            baseInfo.HSSAvg = hssAvg.ToString("f1");
            baseInfo.FSSAvg = fssAvg.ToString("f1");
            baseInfo.NSSAvg = nssAvg.ToString("f1");
            baseInfo.ASSAvg = assAvg.ToString("f1");
            baseInfo.AllAvg = Math.Round((hssAvg + fssAvg + nssAvg + assAvg) / 4.0, 1).ToString("f1");//综合评分
            baseInfo.CommentAllCount = allCount;
            baseInfo.HasPicCount = comments.Where(c => !string.IsNullOrWhiteSpace(c.Imgs)).Count();//有图片评价数量
            baseInfo.HotelID = hotelID;
            baseInfo.Comments = comments;
            return baseInfo;

        }

        /// <summary>
        /// 获取多个酒店的综合评分
        /// </summary>
        /// <param name="hotelIds"></param>
        public Dictionary<int, double> GetHotelsScoreAvg(List<int> hotelIds) 
        {
            var avgDic = new Dictionary<int, double>();
            var comments = new List<Comment>();
            var scoresDt = commentDAL.GetScoresForHotelIds(hotelIds);
            foreach (DataRow r in scoresDt.Rows)
            {
                var m = new Comment();
                m.HotelID = (int)r["HotelID"];
                m.HealthServiceScore = (int)r["HealthServiceScore"];
                m.FacilityServiceScore = (int)r["FacilityServiceScore"];
                m.NetworkServiceScore = (int)r["NetworkServiceScore"];
                m.AttitudeServiceScore = (int)r["AttitudeServiceScore"];
                comments.Add(m);
            }
            foreach (var id in hotelIds)
            {
                var curHotelComments = comments.Where(c => c.HotelID == id);
                var curCount = curHotelComments.Count();
                double hssAvg = curCount <= 0 ? 5.0 : Math.Round(curHotelComments.Sum(c => c.HealthServiceScore) * 1.0 / curCount, 1);// 综合卫生评分
                double fssAvg = curCount <= 0 ? 5.0 : Math.Round(curHotelComments.Sum(c => c.FacilityServiceScore) * 1.0 / curCount, 1);// 综合设施评分
                double nssAvg = curCount <= 0 ? 5.0 : Math.Round(curHotelComments.Sum(c => c.NetworkServiceScore) * 1.0 / curCount, 1);// 综合网络评分
                double assAvg = curCount <= 0 ? 5.0 : Math.Round(curHotelComments.Sum(c => c.AttitudeServiceScore) * 1.0 / curCount, 1);// 综合服务评分
                var allAvg = Math.Round((hssAvg + fssAvg + nssAvg + assAvg) / 4.0, 1);//综合评分
                avgDic.Add(id, allAvg);
            }
            return avgDic;
        }

        /// <summary>
        /// 用户是否已点评过该酒店该订单
        /// </summary>
        /// <returns></returns>
        public bool CurrUserIsComment(int hotelID, int orderID) 
        {
            return commentDAL.ExsitComment(hotelID, orderID);
        }
        /// <summary>
        /// 获取回复消息
        /// </summary>
        /// <param name="cId"></param>
        /// <returns></returns>
        public string GetReplyMsg(int cId)
        {
            var replyMsg = string.Empty;
            var rDt = commentDAL.GetReplyMsgByCId(cId);
            if (rDt.Rows.Count > 0)
            {
                replyMsg = rDt.Rows[0]["Content"] == DBNull.Value ? "" : rDt.Rows[0]["Content"].ToString();
            }
            return replyMsg;
        }

        #endregion
    }
}