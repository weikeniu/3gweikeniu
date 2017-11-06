using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace hotel3g.Models
{
    public class WeiXinHelper
    {
        public string WeiXinID;
        public string Content;
        public string UserWeiXinNO;
        public WeiXinHelper(string _weixinID, string _content, string _userWeiXinNO) {
            this.WeiXinID = _weixinID;
            this.Content = _content;
            this.UserWeiXinNO = _userWeiXinNO;
        }
        public void Send() {
            string takeId=HotelCloud.SqlServer.SQLHelper.Get_Value("select top 1 fakeId from WeiXinUser where weixinID=@weixinID and userWeiXinNO=@userweixinNO order by id desc",HotelCloud.SqlServer.SQLHelper.GetCon(),new Dictionary<string,HotelCloud.SqlServer.DBParam>{
            {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=WeiXinID}},
            {"userweixinNO",new HotelCloud.SqlServer.DBParam{ParamValue=UserWeiXinNO}}
            });

            if(!takeId.Equals("")){
                try
                {
                    var dt = HotelCloud.SqlServer.SQLHelper.Get_DataTable("select top 1 WeiXinUserPwd,WeiXinUserName from WeiXinNO where weixinID=@weixinID", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=WeiXinID}}
                });

                    if (!dt.Rows[0]["WeiXinUserName"].ToString().Equals(""))
                    {
                        WeiXin.Models.WeiXin.WeiXinUsers.SendContent(Content, takeId, dt.Rows[0]["WeiXinUserName"].ToString(), dt.Rows[0]["WeiXinUserPwd"].ToString());
                        HotelCloud.SqlServer.SQLHelper.Run_SQL("insert into weixinContent(weixinID,UserWeiXinNO,Content,type) values(@weixinID,@userWeiXinNO,@content,'reply')", HotelCloud.SqlServer.SQLHelper.GetCon(), new Dictionary<string, HotelCloud.SqlServer.DBParam> { 
                        {"weixinID",new HotelCloud.SqlServer.DBParam{ParamValue=WeiXinID}},
                        {"userWeiXinNO",new HotelCloud.SqlServer.DBParam{ParamValue=UserWeiXinNO}},
                        {"content",new HotelCloud.SqlServer.DBParam{ParamValue=Content}}
                        });
                    }
                }
                catch(Exception ex) { }
            }
            
        }
    }
}