using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using HotelCloud.SqlServer;
using hotel3g.Common;
namespace hotel3g.Models.DAL
{
    /// <summary>
    /// 微可牛 权限类
    /// </summary>
    public static class AuthorityHelper
    {
        public static AuthorityResponse authority(string weixinid)
        {
            AuthorityResponse AuthorityResult = new AuthorityResponse();
            string sql = @"SELECT TOP 1 endabled,examine,pay_examine,branch,canyin,supermarketrket,dingfang_MemberOnly,meeting,edition,style,kefang,TravelEdition,membershow,showmemberprice,comment FROM dbo.WeiXinNO WHERE WeiXinID=@weixinid";
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), new Dictionary<string, DBParam>() { 
            {"weixinid",new DBParam(){ParamValue=weixinid}}
            });
            if (dt != null && dt.Rows.Count > 0)
            {
                var row = dt.Rows[0];
                AuthorityResult.endabled = row["endabled"].TryInt();
                AuthorityResult.examine = row["examine"].TryInt();
                AuthorityResult.branch = row["branch"].TryInt();
                AuthorityResult.pay_examine = row["pay_examine"].TryInt();
                AuthorityResult.canyin = row["canyin"].TryInt();
                AuthorityResult.supermarketrket = row["supermarketrket"].TryInt();
                AuthorityResult.dingfang_MemberOnly = row["dingfang_MemberOnly"].TryInt();
                AuthorityResult.meeting = row["meeting"].TryInt();
                AuthorityResult.edition = row["edition"].TryInt();
                AuthorityResult.style = row["style"].TryInt();
                AuthorityResult.kefang = row["kefang"].TryInt();
                AuthorityResult.TravelEdition = row["TravelEdition"].TryInt();
                AuthorityResult.comment = row["comment"].TryInt();
                AuthorityResult.membershow = row["membershow"].TryInt();
                AuthorityResult.showmemberprice = row["showmemberprice"].TryInt();

                return AuthorityResult;
            }
            return AuthorityResult;
        }
        /// <summary>
        /// 功能模块权限
        /// </summary>
        /// <param name="weixinid"></param>
        /// <returns></returns>
        public static ModuleAuthorityResponse ModuleAuthority(string weixinid)
        {
            string sql = "SELECT TOP 1 * FROM wknModuleAuthority WITH(NOLOCK) WHERE weixinid=@weixinid";
            Dictionary<string, DBParam> Dic = new Dictionary<string, DBParam>();
            Dic.Add("weixinid", new DBParam() { ParamValue = weixinid });
            DataTable dt = SQLHelper.Get_DataTable(sql, SQLHelper.GetCon(), Dic);
            if (dt != null && dt.Rows.Count > 0)
            {
                //存在新版权限则返回新权限
                return dt.ToList<ModuleAuthorityResponse>()[0];
            }
            else
            {
                //没有配置新版权限 尝试读取旧版权限
                AuthorityResponse AuthorityResult = authority(weixinid);
                ModuleAuthorityResponse ModuleAuthorityResult = new ModuleAuthorityResponse()
                {
                    comment = AuthorityResult.comment,
                    edition = AuthorityResult.edition,
                    examine = AuthorityResult.examine,
                    membership_price = AuthorityResult.showmemberprice,
                    membership_room = AuthorityResult.dingfang_MemberOnly,
                    module_chain = AuthorityResult.branch,
                    module_lxs = AuthorityResult.TravelEdition,
                    module_meals = AuthorityResult.canyin,
                    module_meeting = AuthorityResult.meeting,
                    module_member = AuthorityResult.membershow,
                    module_room = AuthorityResult.kefang,
                    module_supermarket = AuthorityResult.supermarketrket,
                    module_zhineng = 0,
                    prepay = AuthorityResult.pay_examine,
                    weixinid = weixinid,
                    module_fenxiao = 1,
                    module_memberbasics = 1

                };
                return ModuleAuthorityResult;
            }
        }
        private static int TryInt(this System.Object Value)
        {
            int IntError = 0;
            if (int.TryParse(Value.ToString(), out IntError))
            {
                return int.Parse(Value.ToString());
            }
            return 0;
        }
    }
}