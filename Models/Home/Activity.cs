using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace WeiXin.Models.Home
{
    public class Activity
    {
        public string InsertActivity(string sportname, string start, string end, string kind, string times, string descripe, string weixinid)
        {
            return new DAL.Activity().InsertActivity(sportname, start, end, kind, times, descripe, weixinid);
        }
        public bool insertPrize(string weixinid, string activityid, string level, string properly, int PrizetypeID, string PrizePrice, string PrizeName)
        {
            return new DAL.Activity().insertPrize(weixinid, activityid, level, properly, PrizetypeID, PrizePrice, PrizeName);
        }

        public DataTable GetActivity(string weixinid)
        {
            return new DAL.Activity().GetActivity(weixinid);
        }
        public bool DelActivity(string weixinid, string sid)
        {
            return new DAL.Activity().DelActivity(weixinid, sid);
        }
        public bool DelPrize(string weixinid, string sid)
        {
            return new DAL.Activity().DelPrize(weixinid, sid);
        }
        public DataTable GetEditActivityByID(string weixinid, string id)
        {
            return new DAL.Activity().GetEditActivityByID(weixinid, id);
        }

        public bool EditActivity(string sportname, string start, string end, string times, string descripe, string weixinid, string id)
        {
            return new DAL.Activity().EditActivity(sportname, start, end, times, descripe, weixinid, id);
        }

        public bool EditPrize(string weixinid, string activityid, string level, string properly, int PrizetypeID, string PrizePrice, string PrizeName)
        {
            return new DAL.Activity().EditPrize(weixinid, activityid, level, properly, PrizetypeID, PrizePrice, PrizeName);
        }

        public DataTable GetPrizeInfo(string weixinid, string sportkind, string activityid)
        {
            return new DAL.Activity().GetPrizeInfo(weixinid, sportkind, activityid);
        }

        public DataTable GetPrizeInfoById(string weixinid, int sId)
        {
            return new DAL.Activity().GetPrizeInfoById(weixinid,sId);
        }

        public int CheckTimes(string weixinid, string userweixinid, string activityid)
        {
            return new DAL.Activity().CheckTimes(weixinid, userweixinid, activityid);
        }
        public DataTable GetJiLv(string activityid, string weixinid)
        {
            return new DAL.Activity().GetJiLv(activityid, weixinid);   
        }
        public bool InsertResult(string activityid, string weixinid, string userweixinid, string result,int prizelevel)
        {
            return new DAL.Activity().InsertResult(activityid, weixinid, userweixinid, result,prizelevel);
        }
        public DataTable AccountPrize(string weixinid, string activityid)
        {
            return new DAL.Activity().AccountPrize(weixinid, activityid);
        }
        public DataTable PrizeInfoBypage(int pageNumber, int pageSize, string weixinid, out int count, string activityid)
        {
            DataTable dt = new DAL.Activity().PrizeInfoBypage(pageNumber, pageSize, weixinid, out count, activityid);
            return dt;
        }
        public DataTable SelectActivity(string weixinid)
        {
            return new DAL.Activity().SelectActivity(weixinid);
        }

        public void InsertCoupon(string weixinid, string moneys, string userweixinno)
        {
             new DAL.Activity().InsertCoupon(weixinid, moneys, userweixinno);
        }
    }
}