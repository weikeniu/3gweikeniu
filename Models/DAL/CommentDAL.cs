using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using HotelCloud.SqlServer;
using hotel3g.Models.Home;

namespace hotel3g.Models.DAL
{
    /// <summary>
    /// 酒店评价DAL
    /// </summary>
    public class CommentDAL
    {
        public DataTable GetListByHotelID(int hotelID)
        {
            string sql = @"SELECT a.*,ISNULL(b.nickname,'') AS NickName,ISNULL(b.photo,'') AS Phone 
FROM dbo.Comment a WITH(NOLOCK)
LEFT JOIN dbo.Member b WITH(NOLOCK) ON a.UserWeixinID = b.userWeiXinNO AND a.HotelWeixinID = b.weixinID
WHERE a.HotelID = @HotelID and a.MsgType = 0 and a.IsShow = 1
ORDER BY a.CreateTime DESC";
            var dt = SQLHelper.Get_DataTable(sql.ToString(), SQLHelper.GetCon(), new Dictionary<string, DBParam> { {"HotelID",new DBParam{ParamValue=hotelID.ToString()}} 
            });
            return dt == null ? new DataTable() : dt;
        }

        public bool InsertModel(Comment model) 
        {
            string sql = @"INSERT INTO dbo.Comment
        ( HotelID ,
          OrderID ,
          UserWeixinID ,
          HotelWeixinID,
          Content ,
          Imgs ,
          HealthServiceScore ,
          FacilityServiceScore ,
          NetworkServiceScore ,
          AttitudeServiceScore ,
          AvgScore ,
          RoomType ,
          IsShow
        )
VALUES  ( @HotelID ,
          @OrderID ,
          @UserWeixinID ,
          @HotelWeixinID,
          @Content ,
          @Imgs ,
          @HealthServiceScore ,
          @FacilityServiceScore ,
          @NetworkServiceScore ,
          @AttitudeServiceScore ,
          @AvgScore ,
          @RoomType ,
          @IsShow
        )";
            var parms = new Dictionary<string, DBParam> 
            { 
                {"HotelID",new DBParam{ParamValue=model.HotelID.ToString()}},
                {"OrderID",new DBParam{ParamValue=model.OrderID.ToString()}},
                {"UserWeixinID",new DBParam{ParamValue=model.UserWeixinID}},
                {"HotelWeixinID",new DBParam{ParamValue=model.HotelWeixinID}},
                {"Content",new DBParam{ParamValue=model.Content}},
                {"Imgs",new DBParam{ParamValue=model.Imgs == null?"":model.Imgs}},
                {"HealthServiceScore",new DBParam{ParamValue=model.HealthServiceScore.ToString()}},
                {"FacilityServiceScore",new DBParam{ParamValue=model.FacilityServiceScore.ToString()}},
                {"NetworkServiceScore",new DBParam{ParamValue=model.NetworkServiceScore.ToString()}},
                {"AttitudeServiceScore",new DBParam{ParamValue=model.AttitudeServiceScore.ToString()}},
                {"AvgScore",new DBParam{ParamValue=model.AvgScore.ToString()}},
                {"RoomType",new DBParam{ParamValue= model.RoomType == null?"":model.RoomType}},
                {"IsShow",new DBParam{ParamValue=(model.IsShow?1:0).ToString()}}
            };
            int n = SQLHelper.Run_SQL(sql,SQLHelper.GetCon(),parms);
            return n > 0;
        }

        public bool ExsitComment(int hotelID, int orderID) 
        {
            string sql = @"SELECT TOP 1 * FROM dbo.Comment WITH(NOLOCK) WHERE OrderID = @OrderID AND HotelID = @HotelID";
            var dt = SQLHelper.Get_DataTable(sql.ToString(), SQLHelper.GetCon(), new Dictionary<string, DBParam> { {"OrderID",new DBParam{ParamValue=orderID.ToString()}},{"HotelID",new DBParam{ParamValue=hotelID.ToString()}}  
            });
            return dt.Rows.Count > 0;
        }

        /// <summary>
        /// 获取多个酒店的评分数据
        /// </summary>
        /// <param name="hotelIds"></param>
        /// <returns></returns>
        public DataTable GetScoresForHotelIds(List<int> hotelIds) 
        {
            string sql = string.Format(@"SELECT a.HotelID,a.HealthServiceScore,a.FacilityServiceScore,a.NetworkServiceScore,a.AttitudeServiceScore 
FROM dbo.Comment a WITH(NOLOCK) WHERE a.IsShow = 1 and a.MsgType = 0 AND a.HotelID in ({0})", string.Join(",", hotelIds));
            var dt = SQLHelper.Get_DataTable(sql.ToString(), SQLHelper.GetCon(), new Dictionary<string, DBParam>());
            return dt == null ? new DataTable() : dt;
        }

        /// <summary>
        /// 更新酒店的综合评分
        /// </summary>
        /// <param name="hotelId"></param>
        /// <param name="score"></param>
        /// <returns></returns>
        public void UpdateHotelAvgScore(int hotelId ,double score) 
        {
            string sql = "UPDATE dbo.Hotel SET CommentAvgScore = @Score WHERE id = @HotelId";
            var dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam> { {"HotelId",new DBParam{ParamValue=hotelId.ToString()}},{"Score",new DBParam{ParamValue=score.ToString()}}  
            });
        }

        /// <summary>
        /// 根据评论ID获取回复消息
        /// </summary>
        /// <param name="cId"></param>
        /// <returns></returns>
        public DataTable GetReplyMsgByCId(int cId)
        {
            string sql = @"SELECT * FROM dbo.Comment WITH(NOLOCK) WHERE MsgID = @CId";
            var dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam> { {"CId",new DBParam{ParamValue=cId.ToString()}} 
            });
            return dt;
        }
    }
}