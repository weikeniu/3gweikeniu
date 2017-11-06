using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Reflection;
using System.Data;
using HotelCloud.SqlServer;

namespace hotel3g.Models
{
    /// <summary>
    /// 旅行社拼团
    /// </summary>
    public static class TravelThemeLogic
    {
        /// <summary>
        /// 获取召集中的主题
        /// </summary>
        /// <param name="weixinid"></param>
        /// <param name="curpage"></param>
        /// <param name="pagesize"></param>
        /// <param name="sort"></param>
        /// <param name="themetype"></param>
        /// <param name="endcity"></param>
        /// <param name="keyworks"></param>
        /// <returns></returns>
        public static List<LXS_ThemeView> GetThemeList(string weixinid, int curpage, int pagesize, int sort, string themetype, string endcity, string keyworks)
        {
            string sqltable = @" SELECT * FROM( SELECT ROW_NUMBER() OVER({0}) rowno, 
 case when userweixinid<>'' then m.nickname else h.SubName end nickname,case when userweixinid<>'' then m.photo else h.hotelLog end img,
 themeid, themename, startcity, endcity, begintime, endtime, days, goingtime, themetype, 
costtype, costmoney, peoplenumber, T_LXS_Theme.content,
case when status=0 then
 case when Convert(char(10),GETDATE(),121) between begintime and endtime then 1 when Convert(char(10),GETDATE(),121)>endtime then 2 else 0 end 
 else status end status,
hotelid, T_LXS_Theme.weixinid, userweixinid, createtime FROM T_LXS_Theme 
LEFT JOIN Member m on m.weixinID=T_LXS_Theme.weixinid and m.userWeiXinNO=T_LXS_Theme.userweixinid
LEFT JOIN Hotel h on h.id=T_LXS_Theme.hotelid)l
where l.status=0 and l.weixinid=@weixinid ";
            if (!string.IsNullOrEmpty(endcity)) 
            {
                sqltable += " and endcity like '%'+@endcity+'%' ";
            }
            if (!string.IsNullOrEmpty(keyworks)) 
            {
                sqltable += " and (themename like '%'+@keyworks+'%' or endcity like '%'+@keyworks+'%' or themetype like '%'+@keyworks+'%')";
            }
            if (!string.IsNullOrEmpty(themetype))//活动类型， 逗号分隔的
            {
                int count = 0; string typewhere = "";
                foreach (string type in themetype.Split(','))
                {
                    if (type != "")
                    {
                        if (count == 0)
                        {
                            typewhere = " themetype like '%" + type + "%'  ";
                        }
                        else
                        {
                            typewhere += " or themetype like '%" + type + "%'  ";
                        }

                        count++;
                    }
                }
                sqltable += " and (" + typewhere + ")";
            }
            string orderby = "order by themeid";
            if (sort == 1) //高价优先
            {
                orderby = "order by costmoney desc";
            }
            if (sort == 2) //低价优先
            {
                orderby = "order by costmoney asc";
            } 
            if (sort == 3) //时间距离优先
            {
                orderby = "order by begintime asc";
            }


            sqltable = string.Format(sqltable, orderby);

            string sql = string.Format("SELECT TOP {0} t.* FROM ({1}) t WHERE t.rowno>{2} ", pagesize, sqltable, (curpage-1) * pagesize);
            return SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
              {"weixinid",new DBParam(){ParamValue=weixinid}},
              {"endcity",new DBParam(){ParamValue=endcity}},
              {"keyworks",new DBParam(){ParamValue=keyworks}}
            }).ToList<LXS_ThemeView>();
        }

        /// <summary>
        /// 获取我的主题[创建+参与]
        /// </summary>
        /// <param name="weixinid"></param>
        /// <param name="curpage"></param>
        /// <param name="pagesize"></param>
        /// <returns></returns>
        public static List<LXS_ThemeView> GetMyThemeList(string userweixinid, int curpage, int pagesize)
        {
            string sqltable = @" SELECT ROW_NUMBER() OVER(order by T_LXS_Theme.themeid) rowno, 
 case when userweixinid<>'' then m.nickname else h.SubName end nickname,case when userweixinid<>'' then m.photo else h.hotelLog end img,
 themeid, themename, startcity, endcity, begintime, endtime, days, goingtime, themetype, 
costtype, costmoney, peoplenumber, T_LXS_Theme.content,
case when status=0 then
 case when Convert(char(10),GETDATE(),121) between begintime and endtime then 1 when Convert(char(10),GETDATE(),121)>endtime then 2 else 0 end 
 else status end status, 
 hotelid, T_LXS_Theme.weixinid, userweixinid, createtime FROM T_LXS_Theme 
LEFT JOIN Member m on m.weixinID=T_LXS_Theme.weixinid and m.userWeiXinNO=T_LXS_Theme.userweixinid
LEFT JOIN Hotel h on h.id=T_LXS_Theme.hotelid
where userweixinid =@userweixinid or T_LXS_Theme.themeid in(select themeid from T_LXS_JoinTheme where ISNULL(state,0)=0  and userweixinid=@userweixinid) ";

            string sql = string.Format("SELECT TOP {0} t.* FROM ({1}) t WHERE t.rowno>{2} ", pagesize, sqltable, (curpage - 1) * pagesize);
            return SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
              {"userweixinid",new DBParam(){ParamValue=userweixinid}}
            }).ToList<LXS_ThemeView>();
        }

        public static DataTable GetMyMemberInfo(string weixinid,string userweixinid)
        {
            string sql = @"select top 1 * from Member where weixinID=@weixinid and userWeiXinNO=@userweixinid";
            return SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
             {"weixinid",new DBParam(){ParamValue=weixinid}},
             {"userweixinid",new DBParam(){ParamValue=userweixinid}}
            });
        }

        public static DataTable GetThemeLocat(string weixinid) 
        {
            string sql = @"select * from (
select city.city ,(select top 1 city from CityInfo ci where CHARINDEX(','+ci.city+',',','+c.endcity+',')>0) as city2 
FROM T_LXS_Theme c WITH(NOLOCK)
, CityInfo city WITH(NOLOCK) where  c.weixinid=@weixinid and CHARINDEX(','+city.city+',',','+c.endcity+',')>0
) t
group by city,city2";
            return SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
             {"weixinid",new DBParam(){ParamValue=weixinid}}
            });
        }

        public static LXS_ThemeView GetThemeModel(string themeid)
        {
            LXS_ThemeView model = new LXS_ThemeView();
            string sql = @"SELECT 
 case when userweixinid<>'' then m.nickname else h.SubName end nickname,case when userweixinid<>'' then m.photo else h.hotelLog end img,
 themeid, themename, startcity, endcity, begintime, endtime, days, goingtime, themetype, 
costtype, costmoney, peoplenumber, T_LXS_Theme.content,T_LXS_Theme.imgurls,
case when status=0 then
 case when Convert(char(10),GETDATE(),121) between begintime and endtime then 1 when Convert(char(10),GETDATE(),121)>endtime then 2 else 0 end 
 else status end status,
hotelid, T_LXS_Theme.weixinid, userweixinid, createtime FROM T_LXS_Theme 
LEFT JOIN Member m on m.weixinID=T_LXS_Theme.weixinid and m.userWeiXinNO=T_LXS_Theme.userweixinid
LEFT JOIN Hotel h on h.id=T_LXS_Theme.hotelid
where T_LXS_Theme.themeid=@themeid";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
              {"themeid",new DBParam(){ParamValue=themeid}}
            });
            if (dt.Rows.Count > 0) 
            {
                model =dt.ToList<LXS_ThemeView>()[0];
            }
            return model;
        }
        
        /// <summary>
        /// 报名参团人列表
        /// </summary>
        /// <param name="themeid"></param>
        /// <returns></returns>
        public static List<LXS_JoinTheme> GetJoinList(string themeid) 
        {
            string sql = @"select joinid, T_LXS_JoinTheme.themeid, T_LXS_JoinTheme.name, phone, message, T_LXS_JoinTheme.userweixinid, T_LXS_JoinTheme.createtime
,(select replycontent+' |' from T_LXS_ReplyJoin where T_LXS_ReplyJoin.themeid=T_LXS_JoinTheme.themeid and T_LXS_ReplyJoin.joinid=T_LXS_JoinTheme.joinid or (T_LXS_ReplyJoin.themeid=T_LXS_JoinTheme.themeid and T_LXS_ReplyJoin.joinid=0) order by T_LXS_ReplyJoin.joinid desc FOR XML PATH(''))replylist
,m.photo as img ,m.nickname,case when T_LXS_Theme.userweixinid='' then 1 else 2 end themetype
 from T_LXS_JoinTheme 
 LEFT JOIN T_LXS_Theme on T_LXS_Theme.themeid=T_LXS_JoinTheme.themeid
 LEFT JOIN Member m on m.userWeiXinNO=T_LXS_JoinTheme.userweixinid and T_LXS_Theme.weixinid=m.weixinID
 where ISNULL(T_LXS_JoinTheme.state,0)=0 and T_LXS_JoinTheme.themeid=@weixinid order by joinid";
            return SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
              {"weixinid",new DBParam(){ParamValue=themeid}}
            }).ToList<LXS_JoinTheme>(); 
        }

        public static int SaveJoin(string username, string phone, string message, string userweixinid, string themeid) 
        {
            string sql = "insert T_LXS_JoinTheme(themeid,name,phone,message,userweixinid,createtime)values(@themeid,@name,@phone,@message,@userweixinid,@createtime)";
            return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
            {
                {"name",new DBParam(){ParamValue=username}},
                {"phone",new DBParam(){ParamValue=phone}},
                {"message",new DBParam(){ParamValue=message}},
                {"userweixinid",new DBParam(){ParamValue=userweixinid}},
                {"themeid",new DBParam(){ParamValue=themeid}},
                {"createtime",new DBParam(){ParamValue=DateTime.Now+""}}
            });
        }

        public static int QuitOut(string uwx, string themeid) 
        {
            string sql = "update T_LXS_JoinTheme set [state]=1 where isnull([state],0)=0 and userweixinid=@uwx and themeid=@themeid";
            return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
            {
                {"themeid",new DBParam(){ParamValue=themeid}},
                {"uwx",new DBParam(){ParamValue=uwx}}
            });
        }

        public static int SaveReply(string replymsg, string joinid, string joinname, string uwx, string themeid)
        {
            string sql = "insert T_LXS_ReplyJoin(joinid, joinname, replycontent, createtime, userweixinid,themeid)values(@joinid, @joinname, @replycontent, @createtime, @userweixinid,@themeid)";
            return SQLHelper.Run_SQL(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>()
            {
                {"joinid",new DBParam(){ParamValue=joinid}},
                {"joinname",new DBParam(){ParamValue=joinname}},
                {"replycontent",new DBParam(){ParamValue=replymsg}},
                {"userweixinid",new DBParam(){ParamValue=uwx}},
                {"createtime",new DBParam(){ParamValue=DateTime.Now+""}},
                {"themeid",new DBParam(){ParamValue=themeid}},
            });
        }

        /// <summary>
        /// 是否已经报名过
        /// </summary>
        public static bool HasSignIn(string userweixinid, string themeid)
        {
            string sql = "select count(1)n from T_LXS_JoinTheme where isnull(state,0)=0 and themeid=@themeid and userweixinid=@userweixinid";
            return Convert.ToInt32(
                SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
                {
                   {"userweixinid",new DBParam(){ParamValue=userweixinid}},
                   {"themeid",new DBParam(){ParamValue=themeid}}
                })
            ) > 0;
        }
        public static LXS_JoinTheme GetJoinModel(string joinid)
        {
            string sql = "select * from T_LXS_JoinTheme where joinid=@joinid";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
                {
                   {"joinid",new DBParam(){ParamValue=joinid}}
                });
            if (dt.Rows.Count > 0)
            {
                return dt.ToList<LXS_JoinTheme>()[0];
            }
            else
            {
                return null;
            }
        }
    }

    /// <summary>
    /// 拼团主题
    /// </summary>
    public class LXS_Theme 
    {
        public int themeid { get; set; }
        public string themename { get; set; }
        public string startcity { get; set; }
        public string endcity { get; set; }
        public DateTime begintime { get; set; }
        public DateTime endtime { get; set; }
        public int days { get; set; }
        public string goingtime { get; set; }
        /// <summary>
        /// 活动类型，多个用逗号分隔“，”
        /// </summary>
        public string themetype { get; set; }
        /// <summary>
        /// 2免费 0人均分摊 1固定费用
        /// </summary>
        public int costtype { get; set; }
        public decimal costmoney { get; set; }

        public int peoplenumber { get; set; }
        public string content { get; set; }
        /// <summary>
        /// 0召集中 1进行中 2已结束
        /// </summary>
        public int status { get; set; }
        public int hotelid { get; set; }
        public string weixinid { get; set; }
        public string userweixinid { get; set; }
        
        /// <summary>
        /// 图片多个用逗号分隔“，”
        /// </summary>
        public string imgurls { get; set; }
        public DateTime createtime { get; set; }

        /// <summary>
        /// 保存主题，返回id
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public string Save(LXS_Theme model) 
        {
            string sql = @"INSERT T_LXS_Theme(themename, startcity, endcity, begintime, endtime, days, goingtime, themetype, costtype, costmoney, peoplenumber, 
content, status, hotelid, weixinid, userweixinid, createtime,imgurls)
VALUES(@themename, @startcity, @endcity, @begintime, @endtime, @days, @goingtime, @themetype, @costtype, @costmoney, @peoplenumber, 
@content, @status, @hotelid, @weixinid, @userweixinid, @createtime,@imgurls); select @@identity";

            return SQLHelper.Get_Value(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() 
            {
               {"themename",new DBParam(){ParamValue=model.themename}},
               {"startcity",new DBParam(){ParamValue=model.startcity}},
               {"endcity",new DBParam(){ParamValue=model.endcity}},
               {"begintime",new DBParam(){ParamValue=model.begintime.ToString("yyyy-MM-dd")}},
               {"endtime",new DBParam(){ParamValue=model.endtime.ToString("yyyy-MM-dd")}},
               {"days",new DBParam(){ParamValue=model.days+""}},
               {"goingtime",new DBParam(){ParamValue=model.goingtime}},
               {"themetype",new DBParam(){ParamValue=model.themetype}},
               {"costtype",new DBParam(){ParamValue=model.costtype+""}},
               {"costmoney",new DBParam(){ParamValue=model.costmoney+""}},
               {"peoplenumber",new DBParam(){ParamValue=model.peoplenumber+""}},
               {"content",new DBParam(){ParamValue=model.content}},
               {"status",new DBParam(){ParamValue=model.status+""}},
               {"hotelid",new DBParam(){ParamValue=model.hotelid+""}},
               {"weixinid",new DBParam(){ParamValue=model.weixinid}},
               {"userweixinid",new DBParam(){ParamValue=model.userweixinid}},
               {"imgurls",new DBParam(){ParamValue=model.imgurls+""}},
               {"createtime",new DBParam(){ParamValue=DateTime.Now.ToString()}}
            });
        }
    }

    public class LXS_ThemeView : LXS_Theme
    {
        public string img { get; set; }
        public string nickname { get; set; }
    }

    /// <summary>
    /// 报名参团
    /// </summary>
    public class LXS_JoinTheme
    {
        //joinid, themeid, name, phone, message, userweixinid, createtime
        public int joinid { get; set; }
        public int themeid { get; set; }
        public string name { get; set; }
        public string phone { get; set; }
        public DateTime createtime { get; set; }
        public string message { get; set; }
        /// <summary>
        /// 回复人微信id
        /// </summary>
        public string userweixinid { get; set; }
        /// <summary>
        /// 1 退出
        /// </summary>
        public int state { get; set; }
        /// <summary>
        /// 回复内容串，"|"分割
        /// </summary>
        public string replylist { get; set; }

        public string img { get; set; }
        public string nickname { get; set; }
        public int themetype { get; set; }
    }

}